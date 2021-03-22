//
//  BaseController.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import UIKit

protocol ControllerDelegate: AnyObject {
    func setupUIComponents()
    func setupUIConstraints()
}

class BaseController: UIViewController, ControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupUIComponents()
        setupUIConstraints()
    }
    
    func setupUIComponents() {
        
    }
    
    func setupUIConstraints() {
        
    }
}
