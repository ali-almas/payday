//
//  TransactionPersistentListUseCase.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

protocol TransactionFetchUseCase {
    func execute(completion: @escaping (Result<Transactions, CoreDataStorageError>) -> Void)
}

final class TransactionFetchUseCaseImpl {
    private let transactionPersistentStorage: TransactionPersistentStorage
    
    init(transactionPersistentStorage: TransactionPersistentStorage) {
        self.transactionPersistentStorage = transactionPersistentStorage
    }
}

extension TransactionFetchUseCaseImpl: TransactionFetchUseCase {
    func execute(completion: @escaping (Result<Transactions, CoreDataStorageError>) -> Void) {
        transactionPersistentStorage.fetchTransactions { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(CoreDataStorageError.readError(error)))
            case .success(let transactions):
                completion(.success(transactions))
            }
        }
    }
}
