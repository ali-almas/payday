//
//  LoginUseCase.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

protocol LoginUseCase {
    func execute(requestValue: LoginModel, completion: @escaping (Result<AuthEntity, NetworkError>)-> Void)
}

final class LoginUseCaseImpl {
    
    private let loginRepository: AuthRepository
    
    init(loginRepository: AuthRepository) {
        self.loginRepository = loginRepository
    }
}

extension LoginUseCaseImpl: LoginUseCase {
    func execute(requestValue: LoginModel, completion: @escaping (Result<AuthEntity, NetworkError>) -> Void) {
        loginRepository.login(body: requestValue) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let entity):
                completion(.success(entity))
            }
        }
    }
}
