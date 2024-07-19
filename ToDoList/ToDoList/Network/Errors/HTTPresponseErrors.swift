//
//  HTTPresponseErrors.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 18.07.2024.
//

import Foundation

enum HTTPresponseErrors: Error {
    case failedDecodingData
    case failedUnwrappingHTTPURLResponse
    case badRequest
    case authorizationError
    case notFound
    case internalServerError
    case unhandledError
}
