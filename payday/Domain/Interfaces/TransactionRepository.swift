//
//  TransactionRepository.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

protocol TransactionRepository {
    func fetchTransactions(completion: @escaping (Result<Transactions, NetworkError>) -> Void)
}
