//
//  HomeViewModel.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

protocol TransactionsViewModelDelegate: ErrorDelegate, ReloadDelegate {
    
}

class TransactionsViewModel: BaseViewModel {
    weak var delegate: TransactionsViewModelDelegate?
    
    private var transactionPersistentListUseCase: TransactionFetchListUseCase
    
    init(transactionPersistentListUseCase: TransactionFetchListUseCase) {
        self.transactionPersistentListUseCase = transactionPersistentListUseCase
    }
    
    var account: AccountEntity?
    var transactions: Transactions = []
}

extension TransactionsViewModel {
    
    private var accountId: Int {
        if let account = self.account {
            return account.id
        } else {
            return -1
        }
    }
    
    func fetchTransactions() {
        executeTransactionPersistentListUseCase()
    }
    
    private func executeTransactionPersistentListUseCase() {
        transactionPersistentListUseCase.execute { (result) in
            switch result {
            case .failure(let error):
                self.delegate?.didReceiveError(error: error)
            case .success(let transactions):
                transactions.forEach { (entity) in
                    if entity.accountID == self.accountId {
                        self.transactions.append(entity)
                    }
                }
                
                self.transactions.sort { (a, b) -> Bool in
                    return a.date > b.date
                }
                
                self.delegate?.didRequireReload()
            }
        }
    }
}
