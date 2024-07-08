//
//  ToDoListModel.swift
//  ToDoList
//
//  Created by Powers Mikaela on 6/27/24.
//

import Foundation


final class TodoListViewModel: ObservableObject {

    // MARK: - Class properties
    @Published var items: [TodoItem] = []
    private(set)var fileCache: FileCacheProtocol

    
    // MARK: - LifeCycle

    init(fileCache: FileCacheProtocol) {
        self.fileCache = fileCache
        loadTodos()
    }

    // MARK: - Internal

    func loadTodos() {
        self.items = fileCache.toDoItems
    }
    
    func removeItem(by id: String) {
        fileCache.removeItem(withId: id)
        loadTodos()
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
}
