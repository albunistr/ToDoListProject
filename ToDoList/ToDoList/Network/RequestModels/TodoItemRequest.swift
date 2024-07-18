//
//  TodoItemRequest.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 18.07.2024.
//

import Foundation

struct TodoItemRequest: Codable {
    let status: String
    let todoItem: TodoItemDecoder
    let revision: Int
    
    init
    (
        status: String = "ok",
        todoItem: TodoItemDecoder,
        revision: Int
    ){
        self.status = status
        self.todoItem = todoItem
        self.revision = revision
    }
}
