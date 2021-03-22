//
//  AccountsListUseCase.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

protocol AccountListUseCase {
    func execute(customerId: Int, completion: @escaping (Result<Accounts, NetworkError>) -> Void)
}

final class AccountListUseCaseImpl {
    private let accountRepository: AccountRepository
    
    init(accountRepository: AccountRepository) {
        self.accountRepository = accountRepository
    }
}

extension AccountListUseCaseImpl: AccountListUseCase {
    func execute(customerId: Int, completion: @escaping (Result<Accounts, NetworkError>) -> Void) {
        accountRepository.fetchAccounts(customerId: customerId) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let accounts):
                completion(.success(accounts))
            }
        }
    }
}
