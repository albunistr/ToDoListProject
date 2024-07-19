//
//  NetworkClientProtocol.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 18.07.2024.
//

import Foundation

protocol NetworkClientProtocol {
    @discardableResult
    func makeRequest<T: Decodable>(
        httpRequest: HTTPrequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> Cancellable? 
}

protocol Cancellable {
    func cancel()
}
