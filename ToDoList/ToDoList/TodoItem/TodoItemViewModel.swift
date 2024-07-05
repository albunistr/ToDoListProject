//
//  TodoItemViewModel.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 23.06.2024.
//

import Foundation
import Combine

class TodoItemViewModel: ObservableObject {
    
    // MARK: - DI
    
    private let fileCache: FileCacheProtocol
    
    // MARK: - Item properties
    
    @Published private(set) var todoItem: TodoItem
    private(set) var isNew: Bool
    weak var delegate: TodoListViewControllerDelegate?
    
    // MARK: - LifeCycle
    
    init(
        fileCache: FileCacheProtocol,
        todoItem: TodoItem,
        isNew: Bool
    ) {
        self.fileCache = fileCache
        self.todoItem = todoItem
        self.isNew = isNew
    }

    // MARK: - Internal vars

    var id: String {
        todoItem.id
    }
    
    // MARK: - Internal methods

    func didTapSaveButton(text: String, importance: TodoItem.Importance, deadline: Date?, color: String, category: TodoItem.Category) {
        let item = TodoItem(
            id: todoItem.id,
            text: text,
            importance: importance,
            deadline: deadline,
            isCompleted: todoItem.isCompleted,
            createdAt: todoItem.createdAt,
            changedAt: Date(),
            color: color,
            category: category
        )
        todoItem = item
        fileCache.addNewOrUpdateItem(todoItem)
        delegate?.didUpdateTodoList()
    }
    
    func didTapDeleteButton() {
        fileCache.removeItem(withId: todoItem.id)
    }

    func didSwitchToggle() {
        let item = TodoItem(
            id: todoItem.id,
            text: todoItem.text,
            importance: todoItem.importance,
            deadline: todoItem.deadline,
            isCompleted: !todoItem.isCompleted,
            createdAt: todoItem.createdAt,
            changedAt: Date(),
            color: todoItem.color,
            category: todoItem.category
        )
        todoItem = item
        fileCache.addNewOrUpdateItem(todoItem)
        delegate?.didUpdateTodoList()
    }
    
    func didCompleted() {
        let item = TodoItem(
            id: todoItem.id,
            text: todoItem.text,
            importance: todoItem.importance,
            deadline: todoItem.deadline,
            isCompleted: true,
            createdAt: todoItem.createdAt,
            changedAt: Date(),
            color: todoItem.color,
            category: todoItem.category
        )
        todoItem = item
        fileCache.addNewOrUpdateItem(todoItem)
    }
    
    func didUnCompleted() {
        let item = TodoItem(
            id: todoItem.id,
            text: todoItem.text,
            importance: todoItem.importance,
            deadline: todoItem.deadline,
            isCompleted: false,
            createdAt: todoItem.createdAt,
            changedAt: Date(),
            color: todoItem.color,
            category: todoItem.category
        )
        todoItem = item
        fileCache.addNewOrUpdateItem(todoItem)
    }
}


extension TodoItemViewModel: Identifiable {}
