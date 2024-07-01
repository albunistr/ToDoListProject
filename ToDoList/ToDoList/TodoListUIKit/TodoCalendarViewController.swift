//
//  TodoListViewController.swift
//  ToDoList
//
//  Created by Powers Mikaela on 30.06.2024.
//

import UIKit

class TodoCalendarViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    
// MARK: - Views
    private let mainLabel = UILabel()
    let collectionViewWithDates = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//    private let scrollViewWithDates = UIScrollView()
//    private let contentViewWithDates = UIView()
    private let scrollViewWithTodos = UIScrollView()
    private let contentViewWithTodos = UIView()
    
// MARK: - Class properties
    var items: [TodoItemViewModel] = []
//    var dates =
//    [
//        Date() + 86400,
//        Date() + 192800,
//        Date() + 259200,
//        Date() + 345600
//    ]
    let dates = [
        (day: "01", month: "Январь"),
        (day: "02", month: "Февраль"),
        (day: "03", month: "Март"),
        (day: "04", month: "Апрель"),
        (day: "05", month: "Май")
        // ... ваши даты ...
    ]
    var selectedDate: Date?
    var selectedButton: UIButton?
    
// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorsUIKit.backPrimary
        setUpLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80) // Размер ячейки
    }
    
}

// MARK: - Extensions

extension TodoCalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoCalendarCell", for: indexPath) as! TodoCalendarCell

        let date = dates[indexPath.item]
        cell.dayLabel.text = date.day
        cell.monthLabel.text = date.month

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
}
private extension TodoCalendarViewController {
    
    private func setUpLayout() {
        configureMainLabel()
        configureCollectionViewWithDates()
        configureScrollViewWithTodos()
        configureContentViewWithTodos()
        prepareCollectionViewWithDates()
        prepareScrollViewWithTodos()
    }
    func configureCollectionViewWithDates() {
        collectionViewWithDates.dataSource = self
        collectionViewWithDates.delegate = self
        collectionViewWithDates.backgroundColor = ColorsUIKit.backPrimary
        collectionViewWithDates.register(TodoCalendarCell.self, forCellWithReuseIdentifier: "TodoCalendarCell")
        
        collectionViewWithDates.translatesAutoresizingMaskIntoConstraints = false
    }
    func prepareCollectionViewWithDates() {
        view.addSubview(collectionViewWithDates)
        
        NSLayoutConstraint.activate([
            collectionViewWithDates.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 20),
            collectionViewWithDates.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionViewWithDates.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionViewWithDates.heightAnchor.constraint(equalToConstant: 100)
        ])

        if let layout = collectionViewWithDates.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
    func configureMainLabel() {
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.textAlignment = .center
        mainLabel.textColor = .black
        mainLabel.text = "Мои дела"
        UIFont.boldSystemFont(ofSize: 24)
        view.addSubview(mainLabel)
        
        mainLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func configureScrollViewWithTodos() {
        scrollViewWithTodos.translatesAutoresizingMaskIntoConstraints = false
        scrollViewWithTodos.backgroundColor = .cyan
        scrollViewWithTodos.showsVerticalScrollIndicator = true
        scrollViewWithTodos.alwaysBounceVertical = true
    }
    
    func configureContentViewWithTodos() {
        contentViewWithTodos.translatesAutoresizingMaskIntoConstraints = false
        contentViewWithTodos.backgroundColor = .gray
    }
    
    func prepareScrollViewWithTodos() {
        view.addSubview(scrollViewWithTodos)
        scrollViewWithTodos.addSubview(contentViewWithTodos)
        
        
        NSLayoutConstraint.activate([
            scrollViewWithTodos.topAnchor.constraint(equalTo: collectionViewWithDates
                .bottomAnchor),
            scrollViewWithTodos.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollViewWithTodos.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollViewWithTodos.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentViewWithTodos.topAnchor.constraint(equalTo: scrollViewWithTodos.topAnchor),
            contentViewWithTodos.bottomAnchor.constraint(equalTo: scrollViewWithTodos.bottomAnchor),
            contentViewWithTodos.leadingAnchor.constraint(equalTo: scrollViewWithTodos.leadingAnchor),
            contentViewWithTodos.trailingAnchor.constraint(equalTo: scrollViewWithTodos.trailingAnchor),
            contentViewWithTodos.heightAnchor.constraint(equalTo: scrollViewWithTodos.heightAnchor),
            contentViewWithTodos.widthAnchor.constraint(equalTo: scrollViewWithTodos.widthAnchor)
        ])
    }
}


