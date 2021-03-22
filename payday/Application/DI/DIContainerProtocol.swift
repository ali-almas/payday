//
//  DIContainerProtocol.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

protocol DIContainerProtocol {
    func register<Component>(type: Component.Type, component: Any)
    func resolve<Component>(type: Component.Type) -> Component
}
