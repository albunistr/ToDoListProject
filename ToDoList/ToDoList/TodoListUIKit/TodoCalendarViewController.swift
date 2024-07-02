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
    let collectionViewWithTodos = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
// MARK: - Class properties
    var items: [TodoItemViewModel]
    var dates: [Date]
    lazy var dict: [String: [TodoItemViewModel]] = {
        var grouped: [String: [TodoItemViewModel]] = [:]
        
        for item in items {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            
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
        configureCollectionViewWithTodos()
        prepareCollectionViewWithDates()
        prepareCollectonViewWithTodos()
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
    func configureCollectionViewWithDates() {
        collectionViewWithDates.dataSource = self
        collectionViewWithDates.delegate = self
        collectionViewWithDates.backgroundColor = ColorsUIKit.backPrimary
        collectionViewWithDates.layer.borderWidth = 1.0
        collectionViewWithDates.layer.borderColor = ColorsUIKit.labelDisable!.cgColor
        collectionViewWithDates.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureCollectionViewWithTodos() {
        collectionViewWithTodos.delegate = self
        collectionViewWithTodos.dataSource = self
        collectionViewWithTodos.backgroundColor = ColorsUIKit.backPrimary
        collectionViewWithTodos.layer.borderWidth = 1.0
        collectionViewWithTodos.layer.borderColor = ColorsUIKit.labelDisable!.cgColor
        collectionViewWithTodos.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func prepareCollectionViewWithDates() {
        collectionViewWithDates.register(TodoCalendarCell.self, forCellWithReuseIdentifier: "TodoCalendarCell")
        collectionViewWithDates.register(TodoCalendarLastCell.self, forCellWithReuseIdentifier: "TodoCalendarLastCell")
        
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
    
    func prepareCollectonViewWithTodos() {
        collectionViewWithTodos.register(TodoCell.self, forCellWithReuseIdentifier: "TodoCell")
        collectionViewWithTodos.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
        
        view.addSubview(collectionViewWithTodos)
        
        NSLayoutConstraint.activate([
            collectionViewWithTodos.topAnchor.constraint(equalTo: collectionViewWithDates.bottomAnchor),
            collectionViewWithTodos.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionViewWithTodos.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionViewWithTodos.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        if let layout = collectionViewWithTodos.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
    }
}



