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
    }
    
    func didTapDeleteButton() {
        fileCache.removeItem(withId: todoItem.id)
    }

    func didSwitchToggle() {
        let index = fileCache.toDoItems.firstIndex(where: { self.id == $0.id }) ?? 0
        let item = fileCache.toDoItems[index].copy(isCompleted: !self.todoItem.isCompleted)
        fileCache.addNewOrUpdateItem(item)
        isNew = true
    }
    
}

extension TodoItemViewModel: Identifiable {}
