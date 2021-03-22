//
//  TransactionListUseCase.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

protocol TransactionListUseCase {
    func execute(completion: @escaping (Result<Transactions, NetworkError>) -> Void)
}

final class TransactionListUseCaseImpl {
    private let transactionRepository: TransactionRepository
    
    init(transactionRepository: TransactionRepository) {
        self.transactionRepository = transactionRepository
    }
}

extension TransactionListUseCaseImpl: TransactionListUseCase {
    func execute(completion: @escaping (Result<Transactions, NetworkError>) -> Void) {
        transactionRepository.fetchTransactions() { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let transactions):
                completion(.success(transactions))
            }
        }
    }
}
