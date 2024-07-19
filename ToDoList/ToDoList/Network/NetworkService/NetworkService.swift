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
    
    // MARK: - Lifecycle
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
}

// MARK: - API methods
extension NetworkService: NetworkServiceProtocol {
    func getAllItems(
        revision: Int,
        completion: @escaping (Result<TodoListRequest, Error>) -> Void
    ) {
        networkClient.makeRequest(httpRequest: makegetAllRequest(), completion: completion)
    }
    
    func getItem(
        id: String,
        completion: @escaping (Result<TodoItemRequest, Error>) -> Void
    ) {
        networkClient.makeRequest(httpRequest: makeGetItemRequest(id), completion: completion)
    }
    
    func updateAllItems(
        revision: Int,
        items: [TodoItem],
        completion: @escaping (Result<TodoListRequest, Error>) -> Void
    ) {
        guard let request = try? makeUpdateAllRequest(revision: revision, items) else {
            completion(.failure(HTTPresponseErrors.failedDecodingData))
            return
        }
        networkClient.makeRequest(httpRequest: request, completion: completion)
    }
    
    func updateItem(
        revision: Int,
        _ item: TodoItem,
        completion: @escaping (Result<TodoItemRequest, Error>) -> Void
        ) {
            guard let request = try? makeUpdateItemRequest(revision: revision, item) else {
                completion(.failure(HTTPresponseErrors.failedDecodingData))
                return
            }
            networkClient.makeRequest(httpRequest: request, completion: completion)
        }
    
    func addItem(
        revision: Int,
        item: TodoItem,
        completion: @escaping (Result<TodoItemRequest, Error>) -> Void
    ) {
        guard let request = try? makeAddItemRequest(revision: revision, item: item) else {
            completion(.failure(HTTPresponseErrors.failedDecodingData))
            return
        }
        networkClient.makeRequest(httpRequest: request, completion: completion)
    }
    
    func deleteItem(
        revision: Int,
        at id: String,
        completion: @escaping (Result<TodoListRequest, Error>) -> Void
        ) {
            networkClient.makeRequest(httpRequest:
                                        makeDeleteItemRequest(revision: revision, id), completion: completion)
        }
}

// MARK: - Making request methods
private extension NetworkService {
    func makegetAllRequest() -> HTTPrequest {
        HTTPrequest(
            route: "\(NetworkService.Constants.baseURL)list",
            headers: [NetworkService.Constants.authorization: NetworkService.Constants.token],
            method: HTTPrequest.Methods.get
        )
    }
    func makeUpdateAllRequest(revision: Int, _ items: [TodoItem])throws -> HTTPrequest {
        let encoder = JSONEncoder()
        
        let codedItems = items.map { TodoItemDecoder(todoItem: $0) }
        let body = TodoListRequest(list: codedItems, revision: revision)
        let data = try encoder.encode(body)
        
        return HTTPrequest(
            route: "\(Constants.baseURL)/list",
            headers: [
                Constants.authorization: Constants.token,
                Constants.lastRevision: "\(revision)",
                Constants.contentType: Constants.jsonType
            ],
            body: data,
            method: HTTPrequest.Methods.patch
        )
    }
    func makeGetItemRequest(_ id: String) -> HTTPrequest {
        HTTPrequest(
            route: "\(Constants.baseURL)/list/\(id)",
            headers: [Constants.authorization: Constants.token],
            method: HTTPrequest.Methods.get
        )
    }
    func makeAddItemRequest(revision: Int, item: TodoItem) throws -> HTTPrequest {
        let requestBody = TodoItemRequest(todoItem: TodoItemDecoder(todoItem: item), revision: revision)
        let encoder = JSONEncoder()
        let data = try encoder.encode(requestBody)
        
        return HTTPrequest(
            route: "\(Constants.baseURL)/list",
            headers: [
                Constants.authorization: Constants.token,
                Constants.lastRevision: "\(revision)",
                Constants.contentType: Constants.jsonType
            ],
            body: data,
            method: HTTPrequest.Methods.patch
        )
    }
    func makeDeleteItemRequest(revision: Int, _ id: String) -> HTTPrequest {
        HTTPrequest(
            route: "\(Constants.baseURL)/list/\(id)",
            headers: [
                Constants.authorization: Constants.token,
                Constants.lastRevision: "\(revision)",
                Constants.contentType: Constants.jsonType
            ],
            method: HTTPrequest.Methods.delete
        )
    }
    func makeUpdateItemRequest(revision: Int, _ item: TodoItem) throws -> HTTPrequest {
        print("REVISIONNNNNNN \(revision)")
            let requestBody = TodoItemRequest(
                todoItem: TodoItemDecoder(todoItem: item),
                revision: revision
            )
            let encoder = JSONEncoder()
            let data = try encoder.encode(requestBody)

            return HTTPrequest(
                route: "\(Constants.baseURL)/list/\(item.id)",
                headers: [
                    Constants.authorization: Constants.token,
                    Constants.lastRevision: "\(revision)",
                    Constants.contentType: Constants.jsonType
                ],
                body: data,
                method: HTTPrequest.Methods.put
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
}
