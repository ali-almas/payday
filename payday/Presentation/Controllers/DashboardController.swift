//
//  DashboardController.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import UIKit

class DashboardController: BaseController {
    
    lazy var viewModel: DashboardViewModel = {
        let container = DIContainer.shared
        let transactionPersistentListUseCase = container.resolve(type: TransactionFetchListUseCase.self)
        let model = DashboardViewModel(transactionListUseCase: transactionPersistentListUseCase)
        model.delegate = self
        return model
    }()
    
    let startDateTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Choose start date"
        field.borderStyle = .roundedRect
        return field
    }()
    
    let endDateTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Choose end date"
        field.borderStyle = .roundedRect
        return field
    }()
    
    let categoryTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Choose category"
        field.borderStyle = .roundedRect
        return field
    }()
    
    let incomeHolder: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    let incomeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Income"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    let incomeTitleValue: UILabel = {
        let label = UILabel()
        label.text = "0.00"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    let expenceHolder: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    let expenceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Expence"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    let expenceTitleValue: UILabel = {
        let label = UILabel()
        label.text = "0.00"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    let dataHolder: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.description())
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        picker.maximumDate = Calendar.current.date(byAdding: .month, value: 0, to: Date())
        picker.minimumDate = Calendar.current.date(byAdding: .month, value: -3, to: Date())
        return picker
    }()
    
    lazy var categoryPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    lazy var toolBar: UIToolbar = {
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let clear = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(didTapClear))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        bar.items = [clear, flexibleSpace, done]
        bar.sizeToFit()
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUIComponents() {
        title = "Dashboard"
        
        incomeHolder.addArrangedSubview(incomeTitleLabel)
        incomeHolder.addArrangedSubview(incomeTitleValue)
        
        expenceHolder.addArrangedSubview(expenceTitleLabel)
        expenceHolder.addArrangedSubview(expenceTitleValue)
        
        dataHolder.addArrangedSubview(startDateTextField)
        dataHolder.addArrangedSubview(endDateTextField)
        dataHolder.addArrangedSubview(categoryTextField)
        dataHolder.addArrangedSubview(incomeHolder)
        dataHolder.addArrangedSubview(expenceHolder)
        
        startDateTextField.inputView = datePicker
        startDateTextField.inputAccessoryView = toolBar
        
        endDateTextField.inputView = datePicker
        endDateTextField.inputAccessoryView = toolBar
        
        categoryTextField.inputView = categoryPicker
        categoryTextField.inputAccessoryView = toolBar
        
        viewModel.startDateValue.observe(on: self, observerBlock: { self.startDateTextField.text = $0 })
        viewModel.endDateValue.observe(on: self, observerBlock: { self.endDateTextField.text = $0 })
        viewModel.totalIncome.observe(on: self, observerBlock: { self.incomeTitleValue.text = $0 })
        viewModel.totalExpence.observe(on: self, observerBlock: { self.expenceTitleValue.text = $0 })
        
        viewModel.fetchTransactions()
    }
    
    override func setupUIConstraints() {
        view.addSubview(dataHolder)
        dataHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        dataHolder.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        dataHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: dataHolder.bottomAnchor, constant: 16).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    @objc func didTapDone() {
        if startDateTextField.isFirstResponder {
            endDateTextField.becomeFirstResponder()
            viewModel.startDate = datePicker.date
        } else if endDateTextField.isFirstResponder {
            categoryTextField.becomeFirstResponder()
            viewModel.endDate = datePicker.date
        } else {
            view.endEditing(true)
        }
    }
    
    @objc func didTapClear() {
        if startDateTextField.isFirstResponder {
            startDateTextField.text = nil
            viewModel.startDate = nil
            endDateTextField.becomeFirstResponder()
        } else if endDateTextField.isFirstResponder {
            endDateTextField.text = nil
            viewModel.endDate = nil
            categoryTextField.becomeFirstResponder()
        } else {
            categoryTextField.text = nil
            viewModel.selectedCategory = ""
            view.endEditing(true)
        }
    }
}

extension DashboardController: DashboardViewModelDelegate {
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

extension DashboardController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.description(), for: indexPath) as? TransactionCell {
            cell.transactionEntity = viewModel.filteredTransactions[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension DashboardController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectedCategory = viewModel.categories[row]
        categoryTextField.text = viewModel.selectedCategory
    }
}
