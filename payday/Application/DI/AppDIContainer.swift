//
//  AppDIContainer.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

final class AppDIContainer {
    let container: DIContainer = DIContainer.shared
    
    lazy var http: HTTP = container.resolve(type: HTTP.self)
    lazy var json: JSON = container.resolve(type: JSON.self)
    lazy var core: CoreDataStorage = container.resolve(type: CoreDataStorage.self)
    lazy var authRepository: AuthRepository = container.resolve(type: AuthRepository.self)
    lazy var accountRepository: AccountRepository = container.resolve(type: AccountRepository.self)
    lazy var transactionRepository: TransactionRepository = container.resolve(type: TransactionRepository.self)
    lazy var transactionPersistentStoarage: TransactionPersistentStorage = container.resolve(type: TransactionPersistentStorage.self)
    
    func register() {
        container.register(type: HTTP.self, component: HTTP())
        container.register(type: JSON.self, component: JSON())
        container.register(type: CoreDataStorage.self, component: CoreDataStorage.shared)
        
        container.register(type: AuthRepository.self, component: AuthRepositoryImpl(json: json, http: http))
        container.register(type: AccountRepository.self, component: AccountRepositoryImpl(http: http))
        container.register(type: TransactionRepository.self, component: TransactionRepositoryImpl(http: http))
        container.register(type: TransactionPersistentStorage.self, component: TransactionPersistentStorageImpl(coreDateStorage: core))
        
        container.register(type: LoginUseCase.self, component: LoginUseCaseImpl(loginRepository: authRepository))
        container.register(type: RegistrationUseCase.self, component: ResgistrationUseCaseImpl(authRepository: authRepository))
        container.register(type: AccountListUseCase.self, component: AccountListUseCaseImpl(accountRepository: accountRepository))
        container.register(type: TransactionListUseCase.self, component: TransactionListUseCaseImpl(transactionRepository: transactionRepository))
        container.register(type: TransactionFetchUseCase.self, component: TransactionFetchUseCaseImpl(transactionPersistentStorage: transactionPersistentStoarage))
        container.register(type: TransactionSaveUseCase.self, component: TransactionSaveUseCaseImpl(transactionPersistentStorage: transactionPersistentStoarage))
        container.register(type: TransactionClearUseCase.self, component: TransactionClearUseCaseImpl(transactionPersistentStorage: transactionPersistentStoarage))
    }
}
