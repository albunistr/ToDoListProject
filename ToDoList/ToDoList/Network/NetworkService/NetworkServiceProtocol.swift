//
//  NetworkServiceProtocol.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 18.07.2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func getAllItems(
        revision: Int,
        completion: @escaping (Result<TodoListRequest, Error>) -> Void
    )
    func getItem(
        id: String,
        completion: @escaping (Result<TodoItemRequest, Error>) -> Void
    )
    
    func updateAllItems(
        revision: Int,
        items: [TodoItem],
        completion: @escaping (Result<TodoListRequest, Error>) -> Void
    )
    
    func updateItem(
        revision: Int,
        _ item: TodoItem,
        completion: @escaping (Result<TodoItemRequest, Error>) -> Void
    )
    
    func addItem(
        revision: Int,
        item: TodoItem,
        completion: @escaping (Result<TodoItemRequest, Error>) -> Void
    )
    
    func deleteItem(
        revision: Int,
        at id: String,
        completion: @escaping (Result<TodoListRequest, Error>) -> Void
    )
}
