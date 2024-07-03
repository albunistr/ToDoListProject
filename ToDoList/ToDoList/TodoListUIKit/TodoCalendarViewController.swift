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
    var collectionViewWithTodos: UICollectionView! = nil
    
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
    
    lazy var sections: [Section] = {
        return dict
            .sorted { $0.key > $1.key }
            .map { Section(date: $0.key, todos: $0.value) }
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
        configureHierarchy()
        configureDataSource()
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
        collectionViewWithTodos = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionViewWithTodos.backgroundColor = ColorsUIKit.backPrimary
        collectionViewWithTodos.translatesAutoresizingMaskIntoConstraints = false
        collectionViewWithTodos.delegate = self
        view.addSubview(collectionViewWithTodos)
        
        NSLayoutConstraint.activate([
            collectionViewWithTodos.topAnchor.constraint(equalTo: view.topAnchor, constant: 155),
            collectionViewWithTodos.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionViewWithTodos.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionViewWithTodos.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44)
            )
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(80)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
           
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(100)
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )
            
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [headerItem]
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                    section.interGroupSpacing = 10
                    section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return section
        }
        return layout
    }
    
    func configureDataSource() {
        collectionViewWithTodos.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionViewWithTodos.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
                
        collectionViewWithTodos.dataSource = self
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
}



struct Section {
    let date: String
    let todos: [TodoItemViewModel]
}
