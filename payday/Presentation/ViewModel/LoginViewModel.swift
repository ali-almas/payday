//
//  SignInViewModel.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

protocol LoginViewModelDelegate: ErrorDelegate {
    func didSussesOnLogin()
}

class LoginViewModel: BaseViewModel {
    weak var delegate: LoginViewModelDelegate?
    
    private var loginUseCase: LoginUseCase
    private var loginModel: LoginModel
    
    init(loginUseCase: LoginUseCase, loginModel: LoginModel) {
        self.loginUseCase = loginUseCase
        self.loginModel = loginModel
    }
    
    func checkForAuthentication() {
        if UserDefaults.standard.isUserAuthenticated {
            delegate?.didSussesOnLogin()
        }
    }
    
    func login() {
        if loginModel.hasEmptyValue {
            delegate?.didReceiveError(error: AuthError.hasEmptyValue)
        } else if loginModel.isEmailInvalid {
            delegate?.didReceiveError(error: AuthError.incorrectEmailFormat)
        } else if loginModel.isPasswordInvalid {
            delegate?.didReceiveError(error: AuthError.incorrectPasswordForamat)
        } else {
            executeLogin()
        }
    }
    
    private func executeLogin() {
        loginUseCase.execute(requestValue: loginModel) { (result) in
            switch result {
            case .failure(let error):
                self.delegate?.didReceiveError(error: AuthError.networkError(error))
            case .success(let auth):
                UserDefaults.standard.customerId = auth.id
                self.delegate?.didSussesOnLogin()
            }
        }
    }
}

extension LoginViewModel {
    
    func update(type: InputType, value: String) {
        switch type {
        case .email:
            loginModel.email = value
        case .password:
            loginModel.password = value
        default:
            fatalError()
        }
    }
    
    var sections: [InputSectionModel] {
        return [
            InputSectionModel(header: "Enter your information to continue",
                              inputs: [InputModel(type: .email, title: "Email"),
                                       InputModel(type: .password, title: "Password")]),
            InputSectionModel(header: "",
                              inputs: [InputModel(type: .button, title: "Login")]),
            InputSectionModel(header: "If you do not have an account",
                              inputs: [InputModel(type: .move, title: "Continue with registration")])
        ]
    }
}
