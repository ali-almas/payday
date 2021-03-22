//
//  TextFieldCell.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import UIKit

enum InputType {
    case name
    case surname
    case phone
    case gender
    case birthday
    case email
    case password
    case button
    case move
    case none
}

protocol InputCellDelegate: AnyObject {
    func didInputValueChanged(type: InputType, value: String)
    func didTapInputButton()
    func didTapMove()
}

class InputCell: UITableViewCell {
    
    weak var delegate: InputCellDelegate?
    
    var inputModel: InputModel? {
        didSet {
            guard let input = self.inputModel else { return }
            
            switch input.type {
            case .move:
                textLabel?.text = input.title
                accessoryType = .disclosureIndicator
                let recognozer = UITapGestureRecognizer(target: self, action: #selector(didTapMove))
                contentView.addGestureRecognizer(recognozer)
                break
            case .gender:
                inputTextField.inputView = pickerView
                inputTextField.placeholder = input.title
                pickerItems = ["Male", "Female"]
                addView(inputTextField)
                break
            case .birthday:
                inputTextField.inputView = datePicker
                inputTextField.placeholder = input.title
                addView(inputTextField)
                break
            case .button:
                inputButton.setTitle(input.title, for: .normal)
                addView(inputButton)
                break
            default:
                inputTextField.isSecureTextEntry = input.type == .password
                inputTextField.placeholder = input.title
                addView(inputTextField)
                break
            }
        }
    }
    
    private var pickerItems: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.pickerView.reloadAllComponents()
            }
        }
    }
    
    lazy var inputTextField: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no
        field.clearButtonMode = .whileEditing
        field.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var inputButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        picker.addTarget(self, action: #selector(didPickDate), for: .valueChanged)
        return picker
    }()
    
    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
    private func addView(_ view: UIView) {
        contentView.addSubview(view)
        view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    @objc private func editingChanged(_ textField: UITextField) {
        guard let type = inputModel?.type else { return }
        guard let text = textField.text else { return }
        
        delegate?.didInputValueChanged(type: type, value: text)
    }
    
    @objc private func didTapButton(_ button: UIButton) {
        delegate?.didTapInputButton()
    }
    
    @objc private func didTapMove() {
        delegate?.didTapMove()
    }
    
    @objc private func didPickDate() {
        guard let type = inputModel?.type else { return }
        inputTextField.text = datePicker.date.standardFormat()
        delegate?.didInputValueChanged(type: type, value: datePicker.date.standardFormat())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InputCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let type = inputModel?.type else { return }
        inputTextField.text = pickerItems[row]
        delegate?.didInputValueChanged(type: type, value: pickerItems[row])
    }
}
