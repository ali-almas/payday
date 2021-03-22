//
//  TransactionCell.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import UIKit

class TransactionCell: UITableViewCell {
    var transactionEntity: TransactionEntity? {
        didSet {
            guard let transaction = transactionEntity else { return }
            
            titleLabel.text = transaction.vendor
            descLabel.text = transaction.date
            amountLabel.text = transaction.amount
        }
    }
    
    var mainHolder: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var innerHolder: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        innerHolder.addArrangedSubview(titleLabel)
        innerHolder.addArrangedSubview(descLabel)
        
        mainHolder.addArrangedSubview(innerHolder)
        mainHolder.addArrangedSubview(amountLabel)
        
        contentView.addSubview(mainHolder)
        mainHolder.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        mainHolder.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        mainHolder.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
