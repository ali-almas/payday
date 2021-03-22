//
//  UserDefaults.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

extension UserDefaults {
    private struct Keys {
        static let customerId = "customer_id"
    }
    
    var customerId: Int? {
        get {
            return integer(forKey: Keys.customerId)
        }
        set {
            setValue(newValue, forKey: Keys.customerId)
        }
    }
    
    var isUserAuthenticated: Bool {
        return string(forKey: Keys.customerId) != nil
    }
}
