//
//  NetworkClient.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 18.07.2024.
//

import Foundation

final class NetworkClient: NetworkClientProtocol {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    
    @discardableResult
    func makeRequest<T: Decodable>
    (
        httpRequest: HTTPrequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> Cancellable? {
        do {
            let urlRequest = try makeURLrequest(httpRequest: httpRequest)
            //убрать делание урла в дургое место
            let task = urlSession.dataTask(with: urlRequest) { data, response, error in
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let response = response as? HTTPURLResponse,
                      let data = data
                else {
                    completion(.failure(Errors.failedRequest))
                    return
                }
                print(data)
                print(response.statusCode)
                let handleResponse = HTTPresponse.handleResponse(for: response)
                switch handleResponse {
                case .success:
                    do {
                        let jsonDecoder = JSONDecoder()
                        let result = try jsonDecoder.decode(T.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            task.resume()
            return task
        } catch {
            completion(.failure(error))
        }
        return nil
    }
    
    func makeURLrequest(httpRequest: HTTPrequest) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: httpRequest.route) else {
            throw Errors.failedMakingURLComponents
        }
        
        let queryItems = httpRequest.queryItems.map { queryItem in
            URLQueryItem(name: queryItem.key, value: queryItem.value)
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw Errors.failedMakingURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpRequest.method.rawValue
        urlRequest.httpBody = httpRequest.body
    
        for header in httpRequest.headers {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
        print(urlRequest)
        return urlRequest
    }
}

extension URLSessionDataTask: Cancellable {}

extension NetworkClient {
    enum Errors: Error {
        case failedMakingURLComponents
        case failedMakingURL
        case failedRequest
    }
}
