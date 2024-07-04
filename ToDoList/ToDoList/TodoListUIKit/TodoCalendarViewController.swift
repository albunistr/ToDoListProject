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
    var tableView: UITableView! = nil
    
// MARK: - Class properties
    var items: [TodoItemViewModel]
    lazy var dates: [String] = {
        var sortedDates = dict.keys.filter { $0 != "Другое" }.sorted()
        sortedDates.append("Другое")
        return sortedDates
    }()
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
    
    var sections: [Section] = []
    
// MARK: - Lifecycle
    init(items: [TodoItemViewModel]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sortedDates = dict.keys.sorted()
        
        sections = sortedDates.map { dateString in
            let tasksForDate = dict[dateString] ?? []
            return Section(date: dateString, todos: tasksForDate)
        }
        setUpLayout()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.reloadData()
        
    }
}

// MARK: - Extensions
private extension TodoCalendarViewController {
    
    private func setUpLayout() {
        configureMainLabel()
        configureCollectionViewWithDates()
        configureHierarchy()
        prepareCollectionViewWithDates()
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
    
    func configureHierarchy() {
        tableView = UITableView()
        tableView.backgroundColor = ColorsUIKit.backPrimary
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 155),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func prepareCollectionViewWithDates() {
        collectionViewWithDates.register(TodoCalendarCell.self, forCellWithReuseIdentifier: "TodoCalendarCell")
        
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
}
