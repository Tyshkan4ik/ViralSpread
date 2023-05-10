//
//  ViewForNavigationBar.swift
//  Viral Spread
//
//  Created by Виталий Троицкий on 08.05.2023.
//

import UIKit

class ViewForNavigationBar: UIView {
    
    //MARK: - Properties
    
    private let labelHealthyPeople: UILabel = {
        let label = UILabel()
        label.text = "👦 :"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueHealthyPeople: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .systemBlue
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelInfectedPeople: UILabel = {
        let label = UILabel()
        label.text = "🧟 :"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueInfectedPeople: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .systemRed
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElement()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    //MARK: - Methods
    
    private func setupElement() {
        addSubview(labelHealthyPeople)
        addSubview(valueHealthyPeople)
        addSubview(labelInfectedPeople)
        addSubview(valueInfectedPeople)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            labelHealthyPeople.topAnchor.constraint(equalTo: topAnchor),
            labelHealthyPeople.bottomAnchor.constraint(equalTo: bottomAnchor),
            labelHealthyPeople.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            valueHealthyPeople.topAnchor.constraint(equalTo: topAnchor),
            valueHealthyPeople.bottomAnchor.constraint(equalTo: bottomAnchor),
            valueHealthyPeople.leadingAnchor.constraint(equalTo: labelHealthyPeople.trailingAnchor, constant: 10),
            
            valueInfectedPeople.topAnchor.constraint(equalTo: topAnchor),
            valueInfectedPeople.bottomAnchor.constraint(equalTo: bottomAnchor),
            valueInfectedPeople.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            labelInfectedPeople.topAnchor.constraint(equalTo: topAnchor),
            labelInfectedPeople.bottomAnchor.constraint(equalTo: bottomAnchor),
            labelInfectedPeople.leadingAnchor.constraint(equalTo: valueHealthyPeople.trailingAnchor, constant: 20),
            labelInfectedPeople.trailingAnchor.constraint(equalTo: valueInfectedPeople.leadingAnchor, constant: -10),
        ])
    }
    
    func setup(valueHealthyPeople: String, valueInfectedPeople: String) {
        
        self.valueInfectedPeople.text = valueInfectedPeople
        self.valueHealthyPeople.text = valueHealthyPeople
    }
}
