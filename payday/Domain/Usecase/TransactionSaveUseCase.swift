//
//  TransactionSaveUseCase.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

protocol TransactionSaveUseCase {
    func execute(transaction: TransactionEntity, completion: @escaping (Result<TransactionEntity, CoreDataStorageError>) -> Void)
}

final class TransactionSaveUseCaseImpl {
    private let transactionPersistentStorage: TransactionPersistentStorage
    
    init(transactionPersistentStorage: TransactionPersistentStorage) {
        self.transactionPersistentStorage = transactionPersistentStorage
    }
}

extension TransactionSaveUseCaseImpl: TransactionSaveUseCase {
    func execute(transaction: TransactionEntity, completion: @escaping (Result<TransactionEntity, CoreDataStorageError>) -> Void) {
        transactionPersistentStorage.saveTransaction(transaction: transaction) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(CoreDataStorageError.saveError(error)))
            case .success(let transaction):
                completion(.success(transaction))
            }
        }
    }
}
