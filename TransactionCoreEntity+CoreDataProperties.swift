//
//  TransactionCoreEntity+CoreDataProperties.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//
//

import Foundation
import CoreData


extension TransactionCoreEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionCoreEntity> {
        return NSFetchRequest<TransactionCoreEntity>(entityName: "TransactionCoreEntity")
    }

    @NSManaged public var id: Int16
    @NSManaged public var amount: Double
    @NSManaged public var account_id: Int16
    @NSManaged public var vendor: String?
    @NSManaged public var category: String?
    @NSManaged public var date: String?

}
