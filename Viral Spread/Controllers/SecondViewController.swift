//
//  SecondViewController.swift
//  Viral Spread
//
//  Created by Виталий Троицкий on 04.05.2023.
//

import UIKit

class SecondViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewForNavigationBar = ViewForNavigationBar()
    
    private let manager = CalculationManager()
    
//    deinit {
//        print(#function)
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        manager.timer?.invalidate()
    }
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionViewFlowLayout()
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionView
        )
        collection.backgroundColor = .clear
        collectionView.scrollDirection = .vertical
        collection.register(CellForCollection.self, forCellWithReuseIdentifier: CellForCollection.identifier)
        //минимальное расстояние между items коллекции
        collectionView.minimumLineSpacing = 10
        // отступ элементов
        collectionView.sectionInset = UIEdgeInsets(
            top: 0,
            left: 10,
            bottom: 10,
            right: 10
        )
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var viewForZoom: UIView = {
        let view = UIView(frame: CGRect(
            x: .zero,
            y: .zero,
            width: view.bounds.width,
            height: view.bounds.height
        ))
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var myScroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .clear
        scroll.frame = view.bounds
        scroll.contentSize = contentSize
        scroll.minimumZoomScale = 0.5
        scroll.maximumZoomScale = 5.0
        return scroll
    }()
    
    private var contentSize: CGSize {
        CGSize(
            width: view.bounds.width,
            height: view.bounds.height
        )
    }
    
    //MARK: - Initializers
    
    init(groupSize: Int, infectionFactor: Int, recalculation: Int) {
        manager.numberOfPeople = groupSize
        manager.valueInfectionFactor = infectionFactor
        manager.timeRecalculation = recalculation
        super.init(nibName: nil, bundle: nil)
        manager.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        manager.updateСounteInNavigationBar()
        setupSettingsNavigationBar()
        addModelsToArray(totalNumberOfPeople: manager.numberOfPeople)
        setupElements()
        setupConstraints()
        myScroll.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    private func setupElements() {
        view.addSubview(myScroll)
        myScroll.addSubview(viewForZoom)
        viewForZoom.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: viewForZoom.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: viewForZoom.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: viewForZoom.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: viewForZoom.bottomAnchor)
        ])
    }
    
    /// Добавление viewForNavigationBar с показателями "Здоров", "Заражен" на navigationBar
    private func setupSettingsNavigationBar() {
        navigationItem.titleView = viewForNavigationBar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    /// Заполняем массив arrayHumanModel в соответствии с заданным количеством людей
    /// - Parameter value: Количество людей
    func addModelsToArray(totalNumberOfPeople: Int) {
        
        var intermediateArray = [HumanModel]()
        for value in 1...totalNumberOfPeople {
            var humanModel = HumanModel()
            humanModel.peopleAround = radiusAroundPeople2(value: value, people: manager.numberOfPeople)
            //print("добавлено окружение к человека № \(value) - \(humanModel.peopleAround)")
            intermediateArray.append(humanModel)
            if intermediateArray.count == manager.maxNumberPeopleInSection || value == totalNumberOfPeople { // -1 ПРОВЕРИТЬ!!!!!!
                manager.arrayHumanModel.append(intermediateArray)
                intermediateArray = [HumanModel]()
            }
        }
        manager.arrayHumanModel2 = manager.arrayHumanModel
    }
    
    
    /// Расчет количества элементов в текущей секции для первичного заполнения коллекции (не используется в пересчете)
    /// - Parameters:
    ///   - section: номер секции
    ///   - totalSections: номер последней секции
    ///   - indexesInLastSection: количество индексов в последней секции
    /// - Returns: количество элементов в необходимой секции
    func numberOfCellsInSection(section: Int, totalSections: Int, indexesInLastSection: Int) -> Int {
        section < totalSections ? 5 : indexesInLastSection
    }
    
    /// Получаем окружение текущего элемента, для первичного заполнения коллекции моделью (не используется в пересчете)
    /// - Parameters:
    ///   - value: номер элемента по порядку из общего числа элементов
    ///   - people: общее количество элементов
    /// - Returns: Сет с окружением текущего элемента
    func radiusAroundPeople2(value: Int, people: Int) -> Set<[Int]> {
        
        var intermediateSet = Set<[Int]>()
        
        /// номер элемента в одномерном массиве (параметр для расчета)
        let newValue = value - 1
        /// номер секции данного элемента в двумерном массиве
        let section = newValue / manager.maxNumberPeopleInSection
        /// номер индекса данного элемента в двумерном массиве
        let index = newValue % manager.maxNumberPeopleInSection
        
        ///количество секций всего от 0
        let totalSections = people / manager.maxNumberPeopleInSection
        /// количество индексов в последней секции
        let indexesInLastSection = (people % manager.maxNumberPeopleInSection)
        
        /// секция сверху
        let sectionUpper = section - 1
        ///секция снизу
        let sectionLower = section + 1
        
        /// индекс слева
        let rowUpper = index - 1
        /// индекс справа
        let rowLower = index + 1
        
        ///количество элементов в секции выше текущей
        let numberOfCellsInSectionUpper = numberOfCellsInSection(section: sectionUpper, totalSections: totalSections, indexesInLastSection: indexesInLastSection)
        
        ///количество элементов в текущей секции
        let numberOfCellsInSectionCurrent = numberOfCellsInSection(section: section, totalSections: totalSections, indexesInLastSection: indexesInLastSection)
        
        ///количество элементов в секции ниже текущей
        let numberOfCellsInSectionLower = numberOfCellsInSection(section: sectionLower, totalSections: totalSections, indexesInLastSection: indexesInLastSection)
        
        //1 проверяем что секция сверху больше или равно 0 и не последняя секция, а также что левый элемент больше или равен 0 и что индекс левого элемента меньше количества элементов в текущей секции
        if sectionUpper >= 0 && sectionUpper <= totalSections && rowUpper >= 0 && rowUpper < numberOfCellsInSectionUpper {
            intermediateSet.insert([section - 1, index - 1])
        }
        //2 проверяем что секция сверху больше или равно 0 и не последняя секция, а также что индекс центрального элемента меньше количество элементов в текущей секции
        if sectionUpper >= 0 && sectionUpper <= totalSections && index < numberOfCellsInSectionUpper {
            intermediateSet.insert([section - 1, index])
        }
        //3 проверяем что секция сверху больше или равно 0 и не последняя секция, а также что индекс правого элемента меньше количества элементов в текущей секции
        if sectionUpper >= 0 && sectionUpper <= totalSections && rowLower < numberOfCellsInSectionUpper {
            intermediateSet.insert([section - 1, index + 1])
        }
        //4 проверяем что текущая секция больше или равно 0 и не последняя секция, а также что левый элемент больше или равен 0 и что индекс левого элемента меньше количества элементов в текущей секции
        if section >= 0 && section <= totalSections && rowUpper >= 0 && rowUpper < numberOfCellsInSectionCurrent  {
            intermediateSet.insert([section, index - 1])
        }
        //5 проверяем что текущая секция больше или равно 0 и не последняя секция, а также что индекс правого элемента меньше количества элементов в текущей секции
        if section >= 0 && section <= totalSections && rowLower < numberOfCellsInSectionCurrent {
            intermediateSet.insert([section, index + 1])
        }
        //6 проверяем что секция снизу больше или равно 0 и не последняя секция, а также что левый элемент больше или равен 0 и что индекс левого элемента меньше количества элементов в текущей секции
        if sectionLower >= 0 && sectionLower <= totalSections && rowUpper >= 0 && rowUpper < numberOfCellsInSectionLower {
            intermediateSet.insert([section + 1, index - 1])
        }
        //7 проверяем что секция снизу больше или равно 0 и не последняя секция, а также что индекс центрального элемента меньше количество элементов в текущей секции
        if sectionLower >= 0 && sectionLower <= totalSections && index < numberOfCellsInSectionLower {
            intermediateSet.insert([section + 1, index])
        }
        //8 проверяем что секция снизу больше или равно 0 и не последняя секция, а также что индекс правого элемента меньше количества элементов в текущей секции
        if sectionLower >= 0 && sectionLower <= totalSections && rowLower < numberOfCellsInSectionLower {
            intermediateSet.insert([section + 1, index + 1])
        }
        return intermediateSet
    }
}

//MARK: - Extension - UICollectionViewDataSource

extension SecondViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.arrayHumanModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.arrayHumanModel[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CellForCollection.identifier,
            for: indexPath
        ) as! CellForCollection
        let model = manager.arrayHumanModel[indexPath.section][indexPath.row]
        myCell.setup(model: model)
        return myCell
    }
}

//MARK: - Extension - UICollectionViewDelegateFlowLayout

extension SecondViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize()
        }
        
        let widthAvailbleForAllItems =  (collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right)
        
        // Suppose we have to create nColunmns
        // widthForOneItem achieved by sunbtracting item spacing if any
        
        let widthForOneItem = widthAvailbleForAllItems / CGFloat(manager.maxNumberPeopleInSection) - flowLayout.minimumInteritemSpacing
        
        // here height is mentioned in xib file or storyboard
        return CGSize(width: CGFloat(widthForOneItem), height: (widthForOneItem * 2))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if manager.arrayHumanModel[indexPath.section][indexPath.row].healthy {
            manager.infectAfterClick(indexPath: indexPath)
        }
    }
    
}

//MARK: - Extension - UIScrollViewDelegate

extension SecondViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return viewForZoom
    }
}

//MARK: - Extension - CalculationManagerDelegate

extension SecondViewController: CalculationManagerDelegate {
    
    func reloadData(indexPath: [IndexPath]) {
        DispatchQueue.main.async { [self] in
            //self.collectionView.reloadData()
            
            collectionView.performBatchUpdates {
                collectionView.reloadItems(at: indexPath)
            }
        }
    }
    
    func didUpdateСounteInNavigationBar(valueHealthyPeople: String, valueInfectedPeople: String) {
        DispatchQueue.main.async {
            self.viewForNavigationBar.setup(valueHealthyPeople: valueHealthyPeople, valueInfectedPeople: valueInfectedPeople)
        }
    }
}
