//
//  ViewController.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import UIKit

class RegistrationController: BaseController {
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.register(InputCell.self, forCellReuseIdentifier: InputCell.description())
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    lazy var viewModel: RegistrationViewModel = {
        let container = DIContainer.shared
        let registrationUseCase = container.resolve(type: RegistrationUseCase.self)
        let registrationModel = RegistrationModel()
        let model = RegistrationViewModel(registrationUseCase: registrationUseCase, registrationModel: registrationModel)
        model.delegate = self
        return model
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupUIComponents() {
        title = "Registration"
        
        viewModel.delegate = self
    }
    
    override func setupUIConstraints() {
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension RegistrationController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].inputs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: InputCell.description(), for: indexPath) as? InputCell {
            cell.inputModel = viewModel.sections[indexPath.section].inputs[indexPath.row]
            cell.delegate = self
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension RegistrationController: InputCellDelegate {
    func didInputValueChanged(type: InputType, value: String) {
        viewModel.update(type: type, value: value)
    }
    
    func didTapInputButton() {
        viewModel.register()
    }
    
    func didTapMove() {
        let vc = RegistrationController()
        show(vc, sender: self)
    }
}

extension RegistrationController: RegistrationViewModelDelegate {
    func didReceiveError(error: Error) {
        if let error = error as? AuthError {
            Message.error(message: error.localizedDescription)
        }
    }
    
    func didSuccessOnRegistration() {
        DispatchQueue.main.async {
            let vc = HomeController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
}
