//
//  AccountRepository.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

protocol AccountRepository {
    func fetchAccounts(customerId: Int, completion: @escaping (Result<Accounts, NetworkError>) -> Void)
}
