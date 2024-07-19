//
//  URL+extension.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 12.07.2024.
//

import Foundation

extension URLSession {
    func dataTask(with request: URLRequest) async throws -> (data: Data, urlResponse: URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = dataTask(with: request) { (data, response, error) in
                if let _ = error {
                    continuation.resume(throwing: Errors.failedMakingURL)
                } else {
                    if let response = response {
                        if let data = data {
                            continuation.resume(returning: (data, response))
                        } else {
                            continuation.resume(throwing: Errors.wrongFormatOfData)
                        }
                    } else {
                        continuation.resume(throwing: Errors.wrongFormatOfResponse)
                    }
                }
            }
            
            if Task.isCancelled {
                task.cancel()
            } else {
                task.resume()
            }
        }
    }
}

extension URLSession {
    enum Errors: Error {
        case failedMakingURL
        case wrongFormatOfData
        case wrongFormatOfResponse
    }
}
