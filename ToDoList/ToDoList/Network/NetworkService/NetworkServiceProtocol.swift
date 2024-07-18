//
//  NetworkServiceProtocol.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 18.07.2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func getAllItems
    (
        revision: Int,
        completion: @escaping (Result<TodoListRequest, Error>) -> Void
    )
    
    func getItem
    (
        id: String,
        completion: @escaping (Result<(TodoItem, Int32), Error>) -> Void
    )
    
    func updateAllItems
    (
        items: [TodoItem],
        completion: @escaping (Result<([TodoItem], Int32), Error>) -> Void
    )
    
    func updateItem
    (
        item: TodoItem,
        completion: @escaping (Result<(TodoItem, Int32), Error>) -> Void
    )
    
    func addItem
    (
        item: TodoItem,
        completion: @escaping (Result<(TodoItem, Int32), Error>) -> Void
    )
    
    func deleteItem
    (
        id: String,
        completion: @escaping (Result<(TodoItem, Int32), Error>) -> Void
    )
}
