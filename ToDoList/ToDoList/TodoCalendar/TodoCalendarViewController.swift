//
//  TodoListViewController.swift
//  ToDoList
//
//  Created by Powers Mikaela on 30.06.2024.
//

import SwiftUI
import UIKit

class TodoCalendarViewController: UIViewController {
    // MARK: - Class properties

    var todocalendarViewModel: TodoCalendarViewModel
    var isShowTodoItemView = false {
        didSet {
            if isShowTodoItemView {
                openTodoItemView()
            } else {
                closeTodoItemView()
                todocalendarViewModel.loadTodos()
                didUpdateTodoList()
            }
        }
    }

    var swiftUIHostingController: UIHostingController<TodoItemViewWrapper>?

    // MARK: - Views

    var collectionViewWithDates: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = ColorsUIKit.backPrimary
        collectionView.layer.borderWidth = 1.0
        collectionView.layer.borderColor = ColorsUIKit.labelDisable!.cgColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    var tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .insetGrouped)
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

    // MARK: - Lifecycle

    init
        (
            todoCalendarViewModel: TodoCalendarViewModel
        ) {
        self.todocalendarViewModel = todoCalendarViewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = false
        setUpLayout()
    }
}

// MARK: - UI extension

private extension TodoCalendarViewController {
    private func setUpLayout() {
        configureCollectionView()
        configureTableView()
        configureButton()
    }

    func configureTableView() {
        tableView.register(TodoCalendarTableViewCell.self, forCellReuseIdentifier: "TodoCalendarTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: collectionViewWithDates.bottomAnchor),
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
            collectionViewWithDates.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
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
        button.addTarget(self, action: #selector(didAddNewButtonTapped), for: .touchUpInside)
    }
}

// MARK: - Add new button extension

private extension TodoCalendarViewController {
    @objc func didAddNewButtonTapped() {
        isShowTodoItemView = true
    }

    func openTodoItemView() {
        let todoItemViewModel = TodoItemViewModel(todoItem: nil, listViewModel: TodoListViewModel(fileCache: todocalendarViewModel.fileCache))
        let todoItemView = TodoItemViewWrapper(isShowed: Binding(get: { self.isShowTodoItemView }, set: { self.isShowTodoItemView = $0 }), todoItemViewModel: todoItemViewModel)
        swiftUIHostingController = UIHostingController(rootView: todoItemView)
        if let controller = swiftUIHostingController {
            present(controller, animated: true)
        }
    }

    func closeTodoItemView() {
        swiftUIHostingController?.dismiss(animated: true)
        swiftUIHostingController = nil
    }
}
