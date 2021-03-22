//
//  ErrorDelegate.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

protocol ErrorDelegate: AnyObject {
    func didReceiveError(error: Error)
}
