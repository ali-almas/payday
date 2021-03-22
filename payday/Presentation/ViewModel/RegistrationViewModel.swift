//
//  RegistrationViewModel.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

protocol RegistrationViewModelDelegate: ErrorDelegate {
    func didSuccessOnRegistration()
}

class RegistrationViewModel: BaseViewModel {
    
    weak var delegate: RegistrationViewModelDelegate?
    
    private var registrationUseCase: RegistrationUseCase
    private var registrationModel: RegistrationModel
    
    init(registrationUseCase: RegistrationUseCase, registrationModel: RegistrationModel) {
        self.registrationUseCase = registrationUseCase
        self.registrationModel = registrationModel
    }
    
    func register() {
        if registrationModel.hasEmptyValue {
            delegate?.didReceiveError(error: AuthError.hasEmptyValue)
        } else if registrationModel.isEmailInvalid {
            delegate?.didReceiveError(error: AuthError.incorrectEmailFormat)
        } else if registrationModel.isPasswordInvalid {
            delegate?.didReceiveError(error: AuthError.incorrectPasswordForamat)
        } else {
            executeRegistration()
        }
    }
    
    private func executeRegistration() {
        registrationUseCase.execute(requestValue: registrationModel) { (result) in
            switch result {
            case .failure(let error):
                self.delegate?.didReceiveError(error: AuthError.networkError(error))
            case .success(_):
                self.delegate?.didSuccessOnRegistration()
            }
        }
    }
}

extension RegistrationViewModel {
    func update(type: InputType, value: String) {
        switch type {
        case .name:
            registrationModel.name = value
        case .surname:
            registrationModel.surname = value
        case .phone:
            registrationModel.phoneNumber = value
        case .email:
            registrationModel.email = value
        case .password:
            registrationModel.password = value
        case .gender:
            registrationModel.gender = value
        case .birthday:
            registrationModel.birthday = value
        default:
            fatalError()
        }
    }
    
    var sections: [InputSectionModel] {
        return [
            InputSectionModel(header: "Enter your information to register",
                              inputs: [InputModel(type: .name, title: "Name"),
                                       InputModel(type: .surname, title: "Surname"),
                                       InputModel(type: .phone, title: "Phone nuber"),
                                       InputModel(type: .email, title: "Email"),
                                       InputModel(type: .password, title: "Password"),
                                       InputModel(type: .gender, title: "Gender"),
                                       InputModel(type: .birthday, title: "Date of birth")]),
            InputSectionModel(header: "",
                              inputs: [InputModel(type: .button, title: "Register")]),
        ]
    }
}
