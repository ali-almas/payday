//
//  SignInModel.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

struct LoginModel: Encodable {
    var email: String = ""
    var password: String = ""
    
    var hasEmptyValue: Bool {
        return ![email, password].allSatisfy { !$0.isEmpty }
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
