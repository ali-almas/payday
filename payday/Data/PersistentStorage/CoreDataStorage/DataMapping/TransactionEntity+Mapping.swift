//
//  TransactionEntity+Mapping.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import CoreData

extension TransactionCoreEntity {
    func toDomain() -> TransactionEntity {
        return .init(id: Int(id),
                     accountID: Int(account_id),
                     amount: String(amount),
                     vendor: vendor ?? "",
                     category: category ?? "",
                     date: date ?? "")
    }
}

extension TransactionEntity {
    func toEntity(context: NSManagedObjectContext) -> TransactionCoreEntity {
        let entity: TransactionCoreEntity = .init(context: context)
        entity.id = Int16(id)
        entity.account_id = Int16(accountID)
        entity.amount = Double(amount) ?? 0
        entity.vendor = vendor
        entity.category = category
        entity.date = date
        return entity
    }
}
