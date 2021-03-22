//
//  RegistrationModel.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

struct RegistrationModel: Encodable {
    var name: String = ""
    var surname: String = ""
    var phoneNumber: String = ""
    var email: String = ""
    var password: String = ""
    var gender: String = ""
    var birthday: String = ""
    
    enum CodingKeys: String, CodingKey {
        case name = "first_name"
        case surname = "last_name"
        case phoneNumber = "phone"
        case birthday = "dob"
        case gender, email, password
    }
    
    var hasEmptyValue: Bool {
        return ![name, surname, phoneNumber, email, password, gender, birthday].allSatisfy { !$0.isEmpty }
    }
    
    var isPasswordInvalid: Bool {
        return password.isEmpty || password.count < 6
    }
    
    var isEmailInvalid: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return !predicate.evaluate(with: email)
    }
}
