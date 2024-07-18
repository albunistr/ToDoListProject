//
//  TodoListRequest.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 18.07.2024.
//

import Foundation

struct TodoListRequest: Codable {
    let status: String
    let list: [TodoItemDecoder]
    let revision: Int
    
    init
    (
        status: String = "ok",
        list: [TodoItemDecoder],
        revision: Int
    ){
        self.status = status
        self.list = list
        self.revision = revision
    }
}
