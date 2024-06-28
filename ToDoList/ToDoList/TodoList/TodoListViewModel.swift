//
//  ToDoListModel.swift
//  ToDoList
//
//  Created by Powers Mikaela on 6/27/24.
//

import Foundation


class TodoListViewModel: ObservableObject {

    // MARK: - DI

    private(set)var fileCache: FileCacheProtocol

    // MARK: - Published properties

    @Published var isNeedCompleted = true {
        didSet {
            self.items = isNeedCompleted ? allItems : withoutCompletedItems
        }
    }
    @Published var items: [TodoItemViewModel] = []
    
    // MARK: - LifeCycle

    init(fileCache: FileCacheProtocol) {
        self.fileCache = fileCache
        loadTodos()
    }

    // MARK: - Internal

    var countOfCompleted: Int {
        return allItems.count - withoutCompletedItems.count
    }

    func didSwitchToggle(index: Int) {
        let item = items[index].todoItem.copy(isCompleted: !items[index].todoItem.isCompleted)
        fileCache.addNewOrUpdateItem(item)
    }

    func addNew() {
        let id = UUID().uuidString
        fileCache.addNewOrUpdateItem(.defaultItem(id: id))
        loadTodos(newID: id)
    }

    func loadTodos(newID: String? = nil) {
        self.items = fileCache.toDoItems.map { .init(fileCache: fileCache, todoItem: $0, isNew: $0.id == newID) }
    }
    func didTapDeleteButton(todoItem: TodoItem) {
        fileCache.removeItem(withId: todoItem.id)
        self.items = fileCache.toDoItems.map { .init(fileCache: fileCache, todoItem: $0, isNew: true) }
    }
    // MARK: - Private

    private var withoutCompletedItems: [TodoItemViewModel] {
        fileCache.toDoItems
            .filter { !$0.isCompleted }
            .map { .init(fileCache: fileCache, todoItem: $0, isNew: false) }
    }
    
    private var allItems: [TodoItemViewModel] {
        fileCache.toDoItems
            .map { .init(fileCache: fileCache, todoItem: $0, isNew: false) }
    }
}
