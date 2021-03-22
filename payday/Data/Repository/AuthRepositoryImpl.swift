//
//  LoginRepositoryImpl.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

final class AuthRepositoryImpl {
    private let json: JSON
    private let http: HTTP
    
    init(json: JSON, http: HTTP) {
        self.json = json
        self.http = http
    }
}

extension AuthRepositoryImpl: AuthRepository {
    func login(body: LoginModel, completion: @escaping (Result<AuthEntity, NetworkError>) -> Void) {
        http.post(endPoint: Endpoint.auth(.login).url, params: json.encode(input: body)) { (data: AuthEntity?, error: NetworkError?) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                completion(.success(data))
            }
        }
    }
    
    func register(body: RegistrationModel, completion: @escaping (Result<AuthEntity, NetworkError>) -> Void) {
        http.post(endPoint: Endpoint.auth(.registration).url, params: json.encode(input: body)) { (data: AuthEntity?, error: NetworkError?) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                completion(.success(data))
            }
        }
    }
}
