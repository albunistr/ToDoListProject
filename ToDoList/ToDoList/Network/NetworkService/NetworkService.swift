//
//  NetworkService.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 18.07.2024.
//

import Foundation

final class NetworkService {
    // MARK: - Class properties
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
}

extension NetworkService: NetworkServiceProtocol {
    func getAllItems
    (
        revision: Int,
        completion: @escaping (Result<TodoListRequest, Error>) -> Void
    ) {
        networkClient.makeRequest(
            httpRequest: makegetAllRequest(),
            completion: completion
        )
    }
    
    func getItem
    (
        id: String,
        completion: @escaping (Result<(TodoItem, Int32), Error>) -> Void
    ) {
        
    }
    
    func updateAllItems
    (
        items: [TodoItem],
        completion: @escaping (Result<([TodoItem], Int32), Error>) -> Void
    ) {
        
    }
    
    func updateItem
    (
        item: TodoItem,
        completion: @escaping (Result<(TodoItem, Int32), Error>) -> Void
    ) {
        
    }
    
    func addItem
    (
        item: TodoItem,
        completion: @escaping (Result<(TodoItem, Int32), Error>) -> Void
    ) {
        
    }
    
    func deleteItem
    (
        id: String,
        completion: @escaping (Result<(TodoItem, Int32), Error>) -> Void
    ) {
        
    }
}

extension NetworkService {
    func makegetAllRequest() -> HTTPrequest {
        HTTPrequest(
            route: "\(NetworkService.Constants.baseURL)list",
            headers: [NetworkService.Constants.authorization: NetworkService.Constants.token],
            method: HTTPrequest.Methods.get
        )
    }
}

extension NetworkService {
    enum Constants {
        static let baseURL = "https://hive.mrdekk.ru/todo/"
        static let token = "Bearer Angrod"
        static let authorization = "Authorization"
        static let lastRevision = "X-Last-Known-Revision"
        static let contentType = "Content-type"
        static let jsonType = "application/json"
    }
    enum Errors: Error {
        case invalidURL
        case invalidResponse
        case invalidRequest
        case noResponseData
        case unknownError
    }
}
