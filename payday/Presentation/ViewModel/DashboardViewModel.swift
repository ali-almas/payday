//
//  DashboardViewModel.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

protocol DashboardViewModelDelegate: ErrorDelegate, ReloadDelegate {
    
}

class DashboardViewModel: BaseViewModel {
    weak var delegate: DashboardViewModelDelegate?
    
    private let transactionListUseCase: TransactionFetchListUseCase
    
    init(transactionListUseCase: TransactionFetchListUseCase) {
        self.transactionListUseCase = transactionListUseCase
    }
    
    private var transactions: Transactions = []
    
    var startDateValue: Observable<String> = Observable<String>.init("")
    var endDateValue: Observable<String> = Observable<String>.init("")
    var totalIncome: Observable<String> = Observable<String>.init("")
    var totalExpence: Observable<String> = Observable<String>.init("")
    
    var filteredTransactions: Transactions = [] {
        didSet {
            delegate?.didRequireReload()
        }
    }
    
    var startDate: Date? {
        didSet {
            guard let date = startDate else { return }
        
            startDateValue.value = date.standardFormat()
            calculateIncomeAndExpence()
        }
    }
    
    var endDate: Date? {
        didSet {
            guard let date = endDate else { return }
            
            endDateValue.value = date.standardFormat()
            calculateIncomeAndExpence()
        }
    }
    
    var categories: [String] {
        var items = transactions.compactMap({ $0.category }).removingDuplicates()
        items.insert("", at: 0)
        return items
    }
    
    var selectedCategory: String = "" {
        didSet {
            calculateIncomeAndExpence()
        }
    }
}

extension DashboardViewModel {
    func fetchTransactions() {
        executeTransactionsListUseCase()
    }
    
    private func executeTransactionsListUseCase() {
        transactionListUseCase.execute { (result) in
            switch result {
            case .failure(let error):
                self.delegate?.didReceiveError(error: error)
            case .success(let transactions):
                self.transactions.append(contentsOf: transactions)
                self.calculateIncomeAndExpence()
            }
        }
    }
    
    private func calculateIncomeAndExpence() {
        
        filteredTransactions = transactions.filter { (entity) -> Bool in
            if !selectedCategory.isEmpty {
                return entity.category == selectedCategory
            } else {
                if !startDateValue.value.isEmpty && !endDateValue.value.isEmpty {
                    return entity.date > startDateValue.value && entity.date < endDateValue.value
                }
            }
            
            return true
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        
        let income: Double = filteredTransactions.reduce(0) { (result, entity) in
            guard let amount = Double(entity.amount) else { return result }
            if !entity.amount.starts(with: "-") {
                return result + amount
            }
            
            return result
        }
        
        let expence: Double = filteredTransactions.reduce(0) { (result, entity) in
            guard let amount = Double(entity.amount) else { return result }
            if entity.amount.starts(with: "-") {
                return result + amount
            }
            
            return result
        }
        
        totalIncome.value = String(format: "%.2f", income)
        totalExpence.value = String(format: "%.2f", expence)
    }
}
