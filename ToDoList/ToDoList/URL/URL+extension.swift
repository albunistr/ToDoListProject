//
//  URL+extension.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 12.07.2024.
//

import Foundation

extension URLSession {
    @discardableResult
    func dataTask(with request: URLRequest,
                  completion: @escaping (Result<(Data, URLResponse), Error>) -> Void) -> URLSessionDataTask {
        let task = self.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else if let data = data, let response = response {
                    completion(.success((data, response)))
                } else {
                    let error = NSError(domain: "com.example.urlsession",
                                        code: -1,
                                        userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
                    completion(.failure(error))
                }
            }
        }
        
        DispatchQueue.global().async {
            task.resume()
        }
        
        return task
    }
}
