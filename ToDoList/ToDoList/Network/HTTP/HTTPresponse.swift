//
//  HTTPresponse.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 18.07.2024.
//

import Foundation

struct HTTPresponse {
    static func unicodeData(_ response: URLResponse, for data: Data, encodind: String.Encoding = .utf8) throws -> Data {
        guard let dataStr = String(data: data, encoding: .utf8) else {
            throw HTTPresponse.Errors.failedDecodingData
        }
        
        return Data(dataStr.utf8)
    }
    
    static func handleResponse(for response: URLResponse) -> Result<Void, HTTPresponse.Errors> {
        guard let response = response as? HTTPURLResponse else {
            return .failure(.failedUnwrappingHTTPURLResponse)
        }
        
        switch response.statusCode {
        case 200: return .success(())
        case 400: return .failure(.badRequest)
        case 401: return .failure(.authorizationError)
        case 404: return .failure(.notFound)
        case 500...599: return .failure(.internalServerError)
        default: return .failure(.unhandledError)
        }
    }
}

extension HTTPresponse {
    enum Errors: Error {
        case failedDecodingData
        case failedUnwrappingHTTPURLResponse
        case badRequest
        case authorizationError
        case notFound
        case internalServerError
        case unhandledError
    }
}
