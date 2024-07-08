//
//  TodoCalendarViewModel.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 08.07.2024.
//

import UIKit

final class TodoCalendarViewModel {
    // MARK: - Private properties
    private var items: [TodoItem] = []
    private(set)var fileCache: FileCacheProtocol
    
    // MARK: - Class properties
    weak var delegate: TodoListViewControllerDelegate?
    var sections: [Section] = []
    
    // MARK: - Lifecycle
    init
    (
        fileCache: FileCacheProtocol
    ) {
        self.fileCache = fileCache
        loadTodos()
    }
    
    func loadTodos() {
        var dict: [String: [TodoItem]] = [:]
        items = fileCache.toDoItems
        
        for item in items {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            
            let dateKey = item.deadline != nil ? dateFormatter.string(from: item.deadline!) : "Другое"
            dict[dateKey, default: []].append(item)
        }
        
        sections.removeAll()
        sections = dict.keys.sorted().map { dateString in
            let tasksForDate = dict[dateString] ?? []
            return Section(date: dateString, todos: tasksForDate)
        }
        delegate?.didUpdateTodoList()
    }

    func addNewOrUpdateItem(_ todoItem: TodoItem? = nil) {
        if let item = todoItem {
            fileCache.addNewOrUpdateItem(item)
        } else {
            let id = UUID().uuidString
            fileCache.addNewOrUpdateItem(.defaultItem(id: id))
        }
        loadTodos()
    }
    func didCompleted(todoItem: TodoItem) {
        let updatedItem = TodoItem(
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
        addNewOrUpdateItem(updatedItem)
    }
    func didUnCompleted(todoItem: TodoItem) {
        let updatedItem = TodoItem(
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
        addNewOrUpdateItem(updatedItem)
    }
        
}

struct Section {
    let date: String
    let todos: [TodoItem]
}


