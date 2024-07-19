//
//  NetworkServiceErrors.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 18.07.2024.
//

import Foundation

enum NetworkServiceErrors: Error {
    case invalidURL
    case invalidResponse
    case invalidRequest
    case noResponseData
    case unknownError
}
