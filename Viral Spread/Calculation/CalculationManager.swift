//
//  CalculationManager.swift
//  Viral Spread
//
//  Created by Виталий Троицкий on 10.05.2023.
//

import Foundation

protocol CalculationManagerDelegate: AnyObject {
    func reloadData(indexPath: [IndexPath])
    /// Обновляет количество здоровых и зараженных людей
    func didUpdateСounteInNavigationBar(valueHealthyPeople: String, valueInfectedPeople: String)
    
//    func calculationManager(
//        _ manager: CalculationManager,
//        didUpdateCounterForNavigationBarWithPeopleValue pValue: String,
//        zombieValue: String
//    )
}

class CalculationManager {
    
    //MARK: - Properties
    
    weak var delegate: CalculationManagerDelegate?
    
    /// Максимальное количество людей в каждой секции
    let maxNumberPeopleInSection = 5
    
    /// Массив зараженных людей с учетом того что им есть кого заражать
    var infectedPeopleArray = Set<[Int]>()
    
    var arrayHumanModel2 = [[HumanModel]]()
    
    /// Количество здоровых людей
    lazy var healthyPeople = numberOfPeople
    
    /// Количество зараженных людей
    var infectedPeople = 0
    
    var timer: Timer?
    
    /// Общее количество людей
    var numberOfPeople: Int = 0
    /// Период пересчета зараженных людей
    var timeRecalculation = 0
    /// инфекционный фактор
    var valueInfectionFactor = 0
    
    var arrayHumanModel = [[HumanModel]]()
    
    private let dispatchQueue = DispatchQueue(label: "Tyshkan4ik.ru")
    
    
    //MARK: - Methods
    
    /// Пересчет количества зараженных людей с учетом заданных параметров
    func recalculation() {
        
        if !(timer?.isValid ?? false) {
    
            DispatchQueue.main.async { [self] in
                timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeRecalculation), repeats: true, block: { _ in
                    
                    self.dispatchQueue.async {
                        // проходим циклом по массиву с зараженными людьми и вызываем заражение окружающих
                        for infectedPeople in self.infectedPeopleArray {
                            
                            //                    print("Человек \( infectedPeople) пытается передать вирус")
                            //                    print("У него в окружении \( self.arrayHumanModel2[infectedPeople[0]][infectedPeople[1]].peopleAround) ")
                            //                    print("В общем массиве зараженных - \(self.infectedPeopleArray)")
                            let section = infectedPeople[0]
                            let index = infectedPeople[1]
                            
                            for _ in 0..<self.valueInfectionFactor {
                                if .random() {
                                    self.accidentalInfection(section: section, index: index)
                                }
                            }
                        }
                        
                        // Проходим по массиву зараженных, если встречаем тех у кого нет окружения удаляем из массива
                        for infectedPeople in self.infectedPeopleArray {
                            self.removeFromInfectedPeopleArray(section: infectedPeople[0], index: infectedPeople[1])
                        }
                        
                        //Проверяем если массив с зараженными людьми пуст то останавливаем таймер
                        if self.infectedPeopleArray.isEmpty {
                            self.timer?.invalidate()
                            print("Таймер остановлен")
                        }
                    }
                })
                RunLoop.current.add(timer!, forMode: .common)
            }
        }
    }
    
    func infectAfterClick(indexPath: IndexPath) {
        
        dispatchQueue.async { [self] in
            let key = [indexPath.section, indexPath.row]
            
            //заражаем человека при клике по нему
            arrayHumanModel[indexPath.section][indexPath.row].healthy = false
            arrayHumanModel2[indexPath.section][indexPath.row].healthy = false
            //print("Окружение человека на которого кликнул - \(manager.arrayHumanModel[indexPath.section][indexPath.row].peopleAround)")
            //добавляем в массив зараженного человека
            infectedPeopleArray.insert(key)
            //manager.infectedPeopleArray[key] = manager.arrayHumanModel[indexPath.section][indexPath.row].peopleAround
            
            //manager.removeFromInfectedPeopleArray(section: indexPath.section, index: indexPath.row)
            removeAroundPeople(section: indexPath.section, index: indexPath.row)
            //collectionView.reloadItems(at: [indexPath])
            delegate?.reloadData(indexPath: [indexPath])
            recalculation()
            healthyPeople -= 1
            infectedPeople += 1
            updateСounteInNavigationBar()
        }
    }
    
    /// Метод передачи вируса от больного к соседним здоровым людям
    /// - Parameters:
    ///   - section: Номер секции больного человека в коллекции
    ///   - index: Индекс больного человека в коллекции
    func accidentalInfection(section: Int, index: Int) {
        
        let human = arrayHumanModel2[section][index].peopleAround.randomElement()
        //var key = [section, index]
        if let human = human {
            arrayHumanModel[human[0]][human[1]].healthy = false
            arrayHumanModel2[human[0]][human[1]].healthy = false
            //добавляем нового зараженного человека в словарь
            infectedPeopleArray.insert(human)
            //удаляем зараженного человека из массива окружения того кто заразил
            arrayHumanModel2[section][index].peopleAround.remove(human)
            
            //ЭТИ ДВА МеТОДА ЗАПУСКАТЬ ПОСЛЕ ВСЕХ ЭТЕРАЦИЙ НА ДАННОМ ПЕРЕСЧЕТЕ
            removeAroundPeople(section: human[0], index: human[1])
            
            // удаляем из числа здоровых одного зараженного
            healthyPeople -= 1
            infectedPeople += 1
            
            var indexPathInfected = IndexPath(row: human[1], section: human[0])
            
            delegate?.reloadData(indexPath: [indexPathInfected])
            
            updateСounteInNavigationBar()
            //print("Сработала reloadData()")
        }
    }
    
    /// Обновляет количество здоровых и зараженных людей
    func updateСounteInNavigationBar() {
        delegate?.didUpdateСounteInNavigationBar(valueHealthyPeople: "\(healthyPeople)", valueInfectedPeople: "\(infectedPeople)")
    }
    
    
    /// если у человека в окружении все заражены удаляем его из массива с зараженными людьми infectedPeopleArray
    func removeFromInfectedPeopleArray(section: Int, index: Int) {
        //print("Проверяет есть ли окружение у \(section)\(index)  - \(arrayHumanModel2[section][index].allpeopleAround)")
        if self.arrayHumanModel2[section][index].allpeopleAround {
            infectedPeopleArray.remove([section, index])
        }
    }
    
    ///удаление зараженного человека из массива окружения всех окружающих его людей
    func removeAroundPeople(section: Int, index: Int) {
        
        for value in arrayHumanModel[section][index].peopleAround {
            arrayHumanModel2[value[0]][value[1]].peopleAround.remove([section, index])
        }
    }
}
