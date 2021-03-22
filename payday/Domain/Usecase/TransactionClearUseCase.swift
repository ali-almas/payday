//
//  TransactionClearUseCase.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

protocol TransactionClearUseCase {
    func execute(completion: @escaping (Result<Bool, Error>) -> Void)
}

final class TransactionClearUseCaseImpl {
    private let transactionPersistentStorage: TransactionPersistentStorage
    
    init(transactionPersistentStorage: TransactionPersistentStorage) {
        self.transactionPersistentStorage = transactionPersistentStorage
    }
}

extension TransactionClearUseCaseImpl: TransactionClearUseCase {
    func execute(completion: @escaping (Result<Bool, Error>) -> Void) {
        transactionPersistentStorage.clearTransactions { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let result):
                if result {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            }
        }
    }
}
