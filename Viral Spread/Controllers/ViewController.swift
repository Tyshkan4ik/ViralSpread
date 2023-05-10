//
//  ViewController.swift
//  Viral Spread
//
//  Created by Виталий Троицкий on 04.05.2023.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    
    private let mainView = MainView()
    
    //MARK: - Methods
    
    override func loadView() {
        view = mainView
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAround))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        mainView.delegate = self
    }
    
    @objc
    private func tapAround() {
        view.endEditing(true)
    }
}

//MARK: - Extensions - MainViewDelegate

extension ViewController: MainViewDelegate {
    
    func actionDidPressedButton(
        _ view: MainView,
        valueGroupSize: Int,
        valueInfectionFactor: Int,
        valueTRecalculation: Int
    ) {
        let controller = SecondViewController(groupSize: valueGroupSize, infectionFactor: valueInfectionFactor, recalculation: valueTRecalculation)
        navigationController?.pushViewController(controller, animated: true)
    }
}
