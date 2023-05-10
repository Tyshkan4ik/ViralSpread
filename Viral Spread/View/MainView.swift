//
//  MainView.swift
//  Viral Spread
//
//  Created by Виталий Троицкий on 04.05.2023.
//

import UIKit

protocol MainViewDelegate: AnyObject {
    /// Действия после нажатия кнопки
    func actionDidPressedButton(
        _ view: MainView,
        valueGroupSize: Int,
        valueInfectionFactor: Int,
        valueTRecalculation: Int
    )
}

/// view для main сцены
class MainView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: MainViewDelegate?
    
    private var valueGroupSize: Int = 0
    private var valueInfectionFactor: Int = 0
    private var valueTimeRecalculation: Int = 0
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "epidemic2")
        imageView.image = image
        imageView.alpha = 0.8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let groupSizeTextField = CustomTextField(
        title: "Количество людей в моделируемой группе",
        placeholder: "Введите количество людей",
        withStepper: false,
        tag: 0
    )
    
    private let infectionFactorTextField = CustomTextField(
        title: "Инфекционный фактор",
        placeholder: "",
        withStepper: true,
        tag: 1
    )
    
    private let timeRecalculationTextField = CustomTextField(
        title: "Период пересчета количества зараженных",
        placeholder: "Введите период пересчета",
        withStepper: false,
        tag: 2
    )
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Запустить моделирование", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didPressedButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemRed
        setupElements()
        setupConstraints()
        
        groupSizeTextField.delegate = self
        infectionFactorTextField.delegate = self
        timeRecalculationTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    private func setupElements() {
        addSubview(backgroundImage)
        addSubview(stackView)
        stackView.addArrangedSubview(groupSizeTextField)
        stackView.addArrangedSubview(infectionFactorTextField)
        stackView.addArrangedSubview(timeRecalculationTextField)
        addSubview(button)
    }
    
    /// Кнопка нажата
    @objc
    private func didPressedButton() {
        delegate?.actionDidPressedButton(
            self,
            valueGroupSize: valueGroupSize,
            valueInfectionFactor: valueInfectionFactor,
            valueTRecalculation: valueTimeRecalculation
        )
    }
    
    private func setupConstraints() {
        let constraint = stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 30)
        constraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            constraint,
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            button.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 50),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            button.heightAnchor.constraint(equalToConstant: 40),
            keyboardLayoutGuide.topAnchor.constraint(greaterThanOrEqualTo: button.bottomAnchor, constant: 20)
        ])
    }
}

//MARK: - Extension - CustomTextFieldDelegate

extension MainView: CustomTextFieldDelegate {
    func getValue(_ textField: CustomTextField, value: String) {
        switch textField.tag {
        case 0:
            if let value = Int(value) {
                valueGroupSize = value
            }
        case 1:
            if let value = Int(value) {
                valueInfectionFactor = value
            }
        case 2:
            if let value = Int(value) {
                valueTimeRecalculation = value
            }
        default:
            break
        }
    }
}
