//
//  TestsForURL.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 12.07.2024.
//

import Foundation

extension URLSession {
    func testURLextension() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1") else {
            print("Invalid URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { result in
            switch result {
            case .success(let (data, response)):
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status code: \(httpResponse.statusCode)")
                }
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received actual data: \(jsonString)")
                } else {
                    print("Failed to convert data to string")
                }
            case .failure(let error):
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }
}
