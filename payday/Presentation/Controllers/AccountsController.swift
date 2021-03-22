//
//  AccountsController.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import UIKit

class AccountsController: BaseController {
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.register(AccountCell.self, forCellReuseIdentifier: AccountCell.description())
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    lazy var viewModel: AccountsViewModel = {
        let container = DIContainer.shared
        let accountListUseCase = container.resolve(type: AccountListUseCase.self)
        let transactionListUseCase = container.resolve(type: TransactionListUseCase.self)
        let transactionSaveUseCase = container.resolve(type: TransactionSaveUseCase.self)
        let transactionClearUseCase = container.resolve(type: TransactionClearUseCase.self)
        let model = AccountsViewModel(accountListUseCase: accountListUseCase,
                                      transactionListUseCase: transactionListUseCase,
                                      transactionSaveUseCase: transactionSaveUseCase,
                                      transactionClearUseCase: transactionClearUseCase)
        model.delegate = self
        return model
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUIComponents() {
        title = "Accounts"
        
        let logOutButton = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(didTapLogOut))
        navigationItem.rightBarButtonItem = logOutButton
        
        viewModel.isLoading.observe(on: self, observerBlock: { Indicator.isAnimating = $0 })
        viewModel.fetchAccounts()
    }
    
    override func setupUIConstraints() {
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc private func didTapLogOut() {
        viewModel.logout()
    }
}

extension AccountsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AccountCell.description(), for: indexPath) as? AccountCell {
            cell.accountEntity = viewModel.accounts[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TransactionsController()
        vc.viewModel.account = viewModel.accounts[indexPath.row]
        show(vc, sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AccountsController: AccountsViewModelDelegate {
    func didReceiveError(error: Error) {
        if let error = error as? NetworkError {
            Message.error(message: error.localizedDescription)
        }
    }
    
    func didRequireReload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didConfirmLogout() {
        dismiss(animated: true, completion: nil)
    }
}
