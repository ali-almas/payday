//
//  Date+Ext.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

extension Date {
    func standardFormat() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: self)
        return formattedDate
    }
}
