//
//  HomeController.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import UIKit

class TransactionsController: BaseController {
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.description())
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    lazy var viewModel: TransactionsViewModel = {
        let container = DIContainer.shared
        let transactionPersistentListUseCase = container.resolve(type: TransactionFetchUseCase.self)
        let model = TransactionsViewModel(transactionPersistentListUseCase: transactionPersistentListUseCase)
        model.delegate = self
        return model
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUIComponents() {
        title = "Transactions"
        
        viewModel.fetchTransactions()
    }
    
    override func setupUIConstraints() {
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension TransactionsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.description(), for: indexPath) as? TransactionCell {
            cell.transactionEntity = viewModel.transactions[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension TransactionsController: TransactionsViewModelDelegate {
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
}
