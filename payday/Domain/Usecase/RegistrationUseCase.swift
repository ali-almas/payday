//
//  RegistrationUseCase.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

protocol RegistrationUseCase {
    func execute(requestValue: RegistrationModel, completion: @escaping (Result<AuthEntity, NetworkError>)-> Void)
}

final class ResgistrationUseCaseImpl {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
}

extension ResgistrationUseCaseImpl: RegistrationUseCase {
    func execute(requestValue: RegistrationModel, completion: @escaping (Result<AuthEntity, NetworkError>) -> Void) {
        authRepository.register(body: requestValue) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let entity):
                completion(.success(entity))
            }
        }
    }
}
