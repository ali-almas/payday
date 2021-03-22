//
//  AccountRepository.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

final class AccountRepositoryImpl {
    private let http: HTTP
    
    init(http: HTTP) {
        self.http = http
    }
}

extension AccountRepositoryImpl: AccountRepository {
    func fetchAccounts(customerId: Int, completion: @escaping (Result<Accounts, NetworkError>) -> Void) {
        http.get(endPoint: Endpoint.account(.accounts).url) { (data: AccountList?, error: NetworkError?) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                let accounts = data.accounts.filter({ $0.customerID == customerId })
                completion(.success(accounts))
            }
        }
    }
}
