//
//  HTTPrequest.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 18.07.2024.
//

import Foundation

struct HTTPrequest {
    let route: String
    let headers: [String: String]
    let body: Data?
    let queryItems: [(key: String, value: String?)]
    let method: HTTPrequest.Methods
    
    init(
        route: String,
        headers: [String : String] = [:],
        body: Data? = nil,
        queryItems: [(key: String, value: String)] = [],
        method: HTTPrequest.Methods
    ) {
        self.route = route
        self.headers = headers
        self.body = body
        self.queryItems = queryItems
        self.method = method
    }
}

extension HTTPrequest {
    enum Methods: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }
}
