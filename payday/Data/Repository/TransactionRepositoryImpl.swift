//
//  TransactionRepository.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

final class TransactionRepositoryImpl {
    private let http: HTTP
    
    init(http: HTTP) {
        self.http = http
    }
}

extension TransactionRepositoryImpl: TransactionRepository {
    func fetchTransactions(completion: @escaping (Result<Transactions, NetworkError>) -> Void) {
        http.get(endPoint: Endpoint.transaction(.transactionList).url) { (data: TransactionList?, error: NetworkError?) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                completion(.success(data.transactions))
            }
        }
    }
}
