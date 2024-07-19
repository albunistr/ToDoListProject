//
//  NeetworkClientErrors.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 18.07.2024.
//

import Foundation

enum NetworkClientErrors: Error {
    case failedMakingURLComponents
    case failedMakingURL
    case failedRequest
}
