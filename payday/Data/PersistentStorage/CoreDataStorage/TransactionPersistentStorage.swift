//
//  TransactionPersistentStorage.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import CoreData

protocol TransactionPersistentStorage {
    func fetchTransactions(completion: @escaping (Result<Transactions, Error>) -> Void)
    func clearTransactions(completion: @escaping (Result<Bool, Error>) -> Void)
    func saveTransaction(transaction: TransactionEntity, completion: @escaping (Result<TransactionEntity, Error>) -> Void)
}

final class TransactionPersistentStorageImpl {
    private let coreDataStorage: CoreDataStorage
    
    init(coreDateStorage: CoreDataStorage) {
        self.coreDataStorage = coreDateStorage
    }
}

extension TransactionPersistentStorageImpl: TransactionPersistentStorage {
    func clearTransactions(completion: @escaping (Result<Bool, Error>) -> Void) {
        coreDataStorage.performBackgroundTask { (context) in
            do {
                let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TransactionCoreEntity")
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
                try context.execute(deleteRequest)
                try context.save()
                completion(.success(true))
            } catch {
                completion(.failure(CoreDataStorageError.deleteError(error)))
            }
        }
    }
    
    func fetchTransactions(completion: @escaping (Result<Transactions, Error>) -> Void) {
        coreDataStorage.performBackgroundTask { (context) in
            do {
                let request: NSFetchRequest = TransactionCoreEntity.fetchRequest()
                let result = try context.fetch(request).map({$0.toDomain()})
                completion(.success(result))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    
    func saveTransaction(transaction: TransactionEntity, completion: @escaping (Result<TransactionEntity, Error>) -> Void) {
        coreDataStorage.performBackgroundTask { (context) in
            do {
                let entity = transaction.toEntity(context: context)
                try context.save()
                completion(.success(entity.toDomain()))
            } catch {
                completion(.failure(CoreDataStorageError.saveError(error)))
            }
        }
    }
}
