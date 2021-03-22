//
//  DIContainer.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

final class DIContainer: DIContainerProtocol {
    
    static let shared = DIContainer()
    
    private init() { }
    
    var components: [String: Any] = [:]
    
    func register<Component>(type: Component.Type, component: Any) {
        components["\(type)"] = component
    }
    
    func resolve<Component>(type: Component.Type) -> Component {
        if let component = components["\(type)"] as? Component {
            return component
        } else {
            fatalError()
        }
    }
    
    func remove<Component>(type: Component.Type) {
        components["\(type)"] = nil
    }
}
