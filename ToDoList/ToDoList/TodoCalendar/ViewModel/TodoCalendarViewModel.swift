//
//  TodoCalendarViewModel.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 08.07.2024.
//

import UIKit
import CocoaLumberjackSwift

final class TodoCalendarViewModel {
    // MARK: - Private properties

    private(set) var fileCache: FileCacheProtocol

    // MARK: - Class properties

    weak var delegate: TodoListViewControllerDelegate?
    var sections: [Section] = []

    // MARK: - Lifecycle

    init (
        fileCache: FileCacheProtocol
    ) {
        self.fileCache = fileCache
        loadTodos()
    }

    func loadTodos() {
        sections.removeAll()
        
        fileCache.loadTodos()
        let items = fileCache.toDoItems

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "YYYY-MM-dd"

        for item in items {
            if let deadline = item.deadline {
                let date = dateFormatter.string(from: deadline)
                if let index = sections.firstIndex(where: { $0.date == date }) {
                    sections[index].todos.append(item)
                } else {
                    sections.append(Section(date: date, todos: [item]))
                }
            } else {
                if let index = sections.firstIndex(where: { $0.date == "Другое" }) {
                    sections[index].todos.append(item)
                } else {
                    sections.append(Section(date: "Другое", todos: [item]))
                }
            }
        }
        sections = sections.sorted { $0.date < $1.date }
        delegate?.didUpdateTodoList()
    }

    func addNewOrUpdateItem(_ todoItem: TodoItem) {
        fileCache.addOrUpdateItem(item: todoItem) { _ in }
        DDLogVerbose("TodoCalendarViewModel updated item")
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
        fileCache.addOrUpdateItem(item: updatedItem) { _ in }
        DDLogVerbose("TodoCalendarViewModel changed to completed")
        loadTodos()
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
        fileCache.addOrUpdateItem(item: updatedItem) { _ in }
        DDLogVerbose("TodoCalendarViewModel changed to uncompleted")
        loadTodos()
    }
    
    func completeButtonPressed(indexPath: IndexPath?) {
        guard let indexPath = indexPath else {
            return
        }
        let item = sections[indexPath.section].todos[indexPath.row]
        fileCache.addOrUpdateItem(item: TodoItem(
            id: item.id,
            text: item.text,
            importance: item.importance,
            deadline: item.deadline,
            isCompleted: true,
            createdAt: item.createdAt,
            changedAt: Date()
        )) { _ in }
        loadTodos()
    }
}

struct Section {
    var date: String
    var todos: [TodoItem]
}
