//
//  TransactionPersistentStorage.swift
//  payday
//
//  Created by AccessBank 2 on 22.03.21.
//

import Foundation

protocol TransactionPersistentStorage {
    func fetchTransactions(completion: @escaping (Result<Transactions, Error>) -> Void)
    func clearTransactions(completion: @escaping (Result<Bool, Error>) -> Void)
    func saveTransaction(transaction: TransactionEntity, completion: @escaping (Result<TransactionEntity, Error>) -> Void)
}
