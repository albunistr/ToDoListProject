//
//  ToDoListModel.swift
//  ToDoList
//
//  Created by Powers Mikaela on 6/27/24.
//

import Foundation
import CocoaLumberjackSwift

final class TodoListViewModel: ObservableObject {
    // MARK: - Class properties

    @Published var items: [TodoItem] = []
    private(set) var fileCache: FileCacheProtocol

    // MARK: - LifeCycle

    init(fileCache: FileCacheProtocol) {
        self.fileCache = fileCache
        loadTodos()
    }

    // MARK: - Internal

    func loadTodos() {
        items = fileCache.toDoItems
    }

    func removeItem(by id: String) {
        fileCache.removeItem(withId: id)
        loadTodos()
        DDLogVerbose("TodoListViewModel removed item")
    }

    func addNewOrUpdateItem(_ todoItem: TodoItem) {
            fileCache.addNewOrUpdateItem(todoItem)
            DDLogVerbose("TodoListViewModel updated item")
        loadTodos()
    }
}
