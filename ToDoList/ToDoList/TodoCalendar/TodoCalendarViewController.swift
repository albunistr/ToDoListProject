//
//  TodoListViewController.swift
//  ToDoList
//
//  Created by Powers Mikaela on 30.06.2024.
//

import UIKit


class TodoCalendarViewController: UIViewController {
// MARK: - Views
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Мои дела"
        return label
    }()
    
    var collectionViewWithDates: UICollectionView = {
       let collectionView =  UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = ColorsUIKit.backPrimary
        collectionView.layer.borderWidth = 1.0
        collectionView.layer.borderColor = ColorsUIKit.labelDisable!.cgColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var tableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = ColorsUIKit.backPrimary
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var button: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: Images.plus), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
// MARK: - Class properties
    var todoListViewModel: TodoListViewModel
    lazy var dates: [String] = {
        var sortedDates = dict.keys.filter { $0 != "Другое" }.sorted()
        sortedDates.append("Другое")
        return sortedDates
    }()
    lazy var dict: [String: [TodoItemViewModel]] = {
        var grouped: [String: [TodoItemViewModel]] = [:]
        
        for item in todoListViewModel.items {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            
            let dateKey = item.todoItem.deadline != nil ? dateFormatter.string(from: item.todoItem.deadline!) : "Другое"
            grouped[dateKey, default: []].append(item)
        }
        return grouped
    }()
    
    var sections: [Section] = []
    
// MARK: - Lifecycle
    init
    (
        todoListviewModel: TodoListViewModel
    ) {
        self.todoListViewModel = todoListviewModel
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
    }
    
}

// MARK: - Extensions
private extension TodoCalendarViewController {
    
    private func setUpLayout() {        
        configureMainLabel()
        configureCollectionView()
        configureTableView()
        configureButton()
    }
    
    func configureMainLabel() {
        view.addSubview(mainLabel)
        
        mainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    func configureTableView() {
        tableView.register(TodoCalendarTableViewCell.self, forCellReuseIdentifier: "TodoCalendarTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 155),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureCollectionView() {
        collectionViewWithDates.register(TodoCalendarCell.self, forCellWithReuseIdentifier: "TodoCalendarCell")
        collectionViewWithDates.dataSource = self
        collectionViewWithDates.delegate = self
        
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
    func configureButton() {
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        button.addTarget(self, action: #selector(openTodoItemEditView), for: .touchUpInside)
    }
}
