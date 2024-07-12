//
//  TodoItemViewModel.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 23.06.2024.
//

import Combine
import SwiftUI
import CocoaLumberjackSwift

final class TodoItemViewModel: ObservableObject {
    // MARK: - Class properties

    @Published var text: String
    @Published var importance: TodoItem.Importance
    @Published var deadline: Date?
    @Published var isOnDeadline: Bool
    @Published var isPickerShowed: Bool
    @Published var color: Color
    @Published var category: TodoItem.Category
    @Published var todoItem: TodoItem?

    var todoListViewModel: TodoListViewModel
    
    // MARK: - Lifecycle
    init(todoItem: TodoItem?, listViewModel: TodoListViewModel) {
        self.todoItem = todoItem
        self.todoListViewModel = listViewModel
        self.text = todoItem?.text ?? "Что надо сделать?"
        self.importance = todoItem?.importance ?? .usual
        self.deadline = todoItem?.deadline ?? nil
        self.isOnDeadline = todoItem?.deadline != nil
        self.isPickerShowed = false
        self.color = Colors.gray.colorStringToColor(todoItem?.color ?? "#FFFFFF")
        self.category = todoItem?.category ?? .other
    }

    func didTapSaveButton() {
        let item = TodoItem(
            id: todoItem?.id ?? UUID().uuidString,
            text: text,
            importance: importance,
            deadline: isOnDeadline ? deadline : nil,
            isCompleted: todoItem?.isCompleted ?? false,
            createdAt: todoItem?.createdAt ?? Date(),
            changedAt: Date(),
            color: color.hexString,
            category: category
        )
        todoListViewModel.addNewOrUpdateItem(item)
        DDLogVerbose("TodoItemViewModel saved item")
    }

    func didTapDeleteButton() {
        guard let id = todoItem?.id else { return }
        todoListViewModel.removeItem(by: id)
        DDLogVerbose("TodoItemViewModel deleted item")
    }
}

extension TodoItemViewModel: Identifiable {}
