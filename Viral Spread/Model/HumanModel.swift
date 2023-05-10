//
//  HumanModel.swift
//  Viral Spread
//
//  Created by Виталий Троицкий on 05.05.2023.
//

import Foundation

struct HumanModel {
    
    var healthy = true
    var peopleAround = Set<[Int]>()
    
    /// Все люди в окружении стали зомби
    var allpeopleAround: Bool {
        return peopleAround.isEmpty ? true : false
    }
    
    var image: String {
        return healthy ? "human1" : "zombi"
    }
}
