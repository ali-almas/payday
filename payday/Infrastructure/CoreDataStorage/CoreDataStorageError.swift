//
//  CoreDataStorageError.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

enum CoreDataStorageError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
}
