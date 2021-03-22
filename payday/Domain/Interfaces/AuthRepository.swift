//
//  LoginRepository.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

protocol AuthRepository {
    func login(body: LoginModel, completion: @escaping (Result<AuthEntity, NetworkError>) -> Void)
    func register(body: RegistrationModel, completion: @escaping (Result<AuthEntity, NetworkError>) -> Void)
}
