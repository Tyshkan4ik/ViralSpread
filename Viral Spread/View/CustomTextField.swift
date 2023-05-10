//
//  CustomTextField.swift
//  Viral Spread
//
//  Created by Виталий Троицкий on 10.05.2023.
//

import UIKit

protocol CustomTextFieldDelegate: AnyObject {
    func getValue(_ textField: CustomTextField, value: String)
}

/// Вью на которой расположены UILabel, UITextField и UIStepper для применения в стеке на MainView
class CustomTextField: UIView {
    
    //MARK: - Properties
    
    weak var delegate: CustomTextFieldDelegate?
    
    private let titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.value = 0
        stepper.minimumValue = 0
        stepper.maximumValue = 8
        stepper.tintColor = .white
        stepper.backgroundColor = .white
        stepper.layer.cornerRadius = 10
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    
    //MARK: - Initializers
    
    init(title: String, placeholder: String, withStepper: Bool, tag: Int) {
        titleLabel.text = title
        textField.placeholder = placeholder
        super.init(frame: .zero)
        self.tag = tag
        if withStepper {
            setupLayoutWithStepper()
        } else {
            setupLayout()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(textField)
        
        textField.addTarget(self, action: #selector(textFieldDidChange1), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupLayoutWithStepper() {
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(stepper)
        
        stepper.addTarget(self, action: #selector(test), for: .valueChanged)
        
        textField.text = "0"
        textField.isEnabled = false
        
        textField.addTarget(self, action: #selector(textFieldDidChange3), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: centerXAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stepper.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            stepper.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 30)
        ])
    }
    
    @objc
    private func test(sender: UIStepper) {
        textField.text = "\(Int(sender.value))"
        delegate?.getValue(self, value: textField.text ?? "")
    }
    @objc
    private func textFieldDidChange1() {
        delegate?.getValue(self, value: textField.text ?? "")
    }
    
    @objc
    private func textFieldDidChange3() {
        delegate?.getValue(self, value: textField.text ?? "")
    }
}
