//
//  CellForCollection.swift
//  Viral Spread
//
//  Created by Виталий Троицкий on 05.05.2023.
//

import UIKit

class CellForCollection: UICollectionViewCell {
    
    //MARK: - Properties
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private let imagePeople: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 20
        contentView.addSubview(imagePeople)
        
        NSLayoutConstraint.activate([
            imagePeople.topAnchor.constraint(equalTo: contentView.topAnchor),
            imagePeople.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imagePeople.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imagePeople.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    //MARK: - Methods
    
    /// Установка значений в ячейку коллекции
    /// - Parameter model: Модель данных - HumanModel
    func setup(model: HumanModel) {
        imagePeople.image = UIImage(named: model.image)
    }
}
