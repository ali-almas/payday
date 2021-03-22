//
//  AccountsViewModel.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

protocol AccountsViewModelDelegate: ErrorDelegate, ReloadDelegate {
    func didConfirmLogout()
}

class AccountsViewModel: BaseViewModel {
    weak var delegate: AccountsViewModelDelegate?
    
    private let accountListUseCase: AccountListUseCase
    private let transactionListUseCase: TransactionListUseCase
    private let transactionSaveUseCase: TransactionSaveUseCase
    private let transactionClearUseCase: TransactionClearUseCase
    
    init(accountListUseCase: AccountListUseCase,
         transactionListUseCase: TransactionListUseCase,
         transactionSaveUseCase: TransactionSaveUseCase,
         transactionClearUseCase: TransactionClearUseCase) {
        self.accountListUseCase = accountListUseCase
        self.transactionListUseCase = transactionListUseCase
        self.transactionSaveUseCase = transactionSaveUseCase
        self.transactionClearUseCase = transactionClearUseCase
    }
    
    var accounts: Accounts = []
    var isLoading: Observable<Bool> = Observable.init(false)
}

extension AccountsViewModel {
    func logout() {
        UserDefaults.standard.customerId = nil
        delegate?.didConfirmLogout()
    }
    
    func fetchAccounts() {
        if let id = UserDefaults.standard.customerId {
            executeAccountListUseCase(customerId: id)
        }
    }
    
    private func executeAccountListUseCase(customerId: Int) {
        self.isLoading.value = true
        accountListUseCase.execute(customerId: customerId) { (result) in
            self.isLoading.value = false
            switch result {
            case .failure(let error):
                self.delegate?.didReceiveError(error: error)
            case .success(let accounts):
                self.accounts = accounts
                self.executeTransactionListUseCase()
                self.delegate?.didRequireReload()
            }
        }
    }
    
    private func executeTransactionListUseCase() {
        self.isLoading.value = true
        transactionListUseCase.execute { (result) in
            self.isLoading.value = false
            switch result {
            case .failure(let error):
                self.delegate?.didReceiveError(error: error)
            case .success(let transactions):
                self.executeTransactionClearUseCase(transactions: transactions)
            }
        }
    }
    
    private func executeTransactionClearUseCase(transactions: Transactions) {
        transactionClearUseCase.execute { (result) in
            switch result {
            case .failure(let error):
                self.delegate?.didReceiveError(error: error)
            case .success(let value):
                if value {
                    transactions.forEach { (entity) in
                        if self.accounts.contains(where: {$0.id == entity.accountID}) {
                            self.executeTransactionSaveListUseCase(transaction: entity)
                        }
                    }
                    
                    self.delegate?.didRequireReload()
                }
            }
        }
    }
    
    private func executeTransactionSaveListUseCase(transaction: TransactionEntity) {
        self.isLoading.value = true
        transactionSaveUseCase.execute(transaction: transaction) { (result) in
            self.isLoading.value = false
            switch result {
            case .failure(let error):
                self.delegate?.didReceiveError(error: error)
            case .success(_):
                self.delegate?.didRequireReload()
            }
        }
    }
}
