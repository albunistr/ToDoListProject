//
//  TodoItemPersistent.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 26.07.2024.
//

import Foundation
import SwiftData

@Model
final class TodoItemPersistent: Identifiable {
    
    @Attribute(.unique) let id: String
    let text: String
    let importance: TodoItem.Importance
    let deadline: Date?
    let isCompleted: Bool
    let createdAt: Date
    let changedAt: Date?
    let color: String
    let category: TodoItem.Category
    
    // MARK: - Init
    init(
        todoItem: TodoItem
    ) {
        self.id = todoItem.id
        self.text = todoItem.text
        self.importance = todoItem.importance
        self.deadline = todoItem.deadline
        self.isCompleted = todoItem.isCompleted
        self.createdAt = todoItem.createdAt
        self.changedAt = todoItem.changedAt
        self.color = todoItem.color
        self.category = todoItem.category
    }
    
    func doTodoItem() -> TodoItem {
        return TodoItem(
            id: self.id,
            text: self.text,
            importance: self.importance,
            deadline: self.deadline,
            isCompleted: self.isCompleted,
            createdAt: self.createdAt,
            changedAt: self.changedAt,
            color: self.color,
            category: self.category)
    }
}
