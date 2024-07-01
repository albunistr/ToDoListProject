//
//  TodoListViewController.swift
//  ToDoList
//
//  Created by Powers Mikaela on 30.06.2024.
//

import UIKit

class TodoCalendarViewController: UIViewController {
    
// MARK: - Views
    private let mainLabel = UILabel()
    let collectionViewWithDates = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let scrollViewWithTodos = UIScrollView()
    private let contentViewWithTodos = UIView()
    
// MARK: - Class properties
    var items: [TodoItemViewModel]
    var dates: [Date]
    lazy var dict: [String: [TodoItemViewModel]] = {
        var grouped: [String: [TodoItemViewModel]] = [:]
        
        for item in items {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd\n\nMMMM"
            
            let dateKey = item.todoItem.deadline != nil ? dateFormatter.string(from: item.todoItem.deadline!) : "Другое"
            grouped[dateKey, default: []].append(item)
        }
        return grouped
    }()
    
// MARK: - Lifecycle
    init(items: [TodoItemViewModel]) {
        self.items = items
        self.dates = items.compactMap { $0.todoItem.deadline }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
    }
}

// MARK: - Extensions
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
        collectionViewWithDates.register(TodoCalendarLastCell.self, forCellWithReuseIdentifier: "TodoCalendarLastCell")
        collectionViewWithDates.layer.borderWidth = 1.0
        collectionViewWithDates.layer.borderColor = ColorsUIKit.labelDisable!.cgColor
        
        collectionViewWithDates.translatesAutoresizingMaskIntoConstraints = false
    }
    func prepareCollectionViewWithDates() {
        view.addSubview(collectionViewWithDates)
        
        NSLayoutConstraint.activate([
            collectionViewWithDates.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 10),
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
        mainLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        mainLabel.text = "Мои дела"
        view.addSubview(mainLabel)
        
        mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func configureScrollViewWithTodos() {
        scrollViewWithTodos.translatesAutoresizingMaskIntoConstraints = false
        scrollViewWithTodos.backgroundColor = ColorsUIKit.backPrimary
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
            scrollViewWithTodos.topAnchor.constraint(equalTo: collectionViewWithDates.bottomAnchor),
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



