//
//  LoginEntity.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

struct AuthEntity: Codable {
    let id: Int
    let firstName, lastName, gender, email: String
    let password, dob, phone: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case gender, email, password, dob, phone
    }
}
