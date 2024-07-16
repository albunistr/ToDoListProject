//
//  URL+extension.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 12.07.2024.
//

import Foundation

extension URLSession {
    func dataTask(with request: URLRequest,
                  completion: @escaping (Result<(Data, URLResponse), Error>) -> Void) -> URLSessionDataTask {
        return try await withCheckedContinuation  { continuation in
            let task = dataTask(with: request) { (data, response, error) in
                if let error = error {
                    continuation.resume(throwing: "Error: \(error). Failed making URL.")
                } else {
                    if let response = response {
                        if let data = data {
                            continuation.resume(returning: (data, response))
                        } else {
                            continuation.resume(throwing: "Error: \(error). Wrong format of data.")
                        }
                    } else {
                        continuation.resume(throwing: "Error: \(error). Wrong format of response.")
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
