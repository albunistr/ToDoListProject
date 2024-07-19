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
        urlSession.configuration.timeoutIntervalForRequest = 30.0
    }
    
    @discardableResult
    func makeRequest<T: Decodable>(
        httpRequest: HTTPrequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> Cancellable? {
        do {
            let urlRequest = try makeURLrequest(httpRequest: httpRequest)
            
            let task = self.urlSession.dataTask(with: urlRequest) { data, response, error in
                guard let response = response as? HTTPURLResponse,
                      let data = data,
                      let stringData = String(data: data, encoding: .utf8)
                else {
                    NetworkClient.executeCompletionOnMainThread {
                        completion(.failure(HTTPresponseErrors.failedUnwrappingHTTPURLResponse))
                    }
                    return
                }
                let unwrappedData = Data(stringData.utf8)
                let handledResponse = HTTPresponse.handleResponse(for: response)
                
                switch handledResponse {
                case .success:
                    print("Status code od request:", response.statusCode)
                    print("Get:", data)
                    let jsonDecoder = JSONDecoder()
//                    jsonDecoder.keyDecodingStrategy = request.keyDecodingStrategy
//                    jsonDecoder.dateDecodingStrategy = request.dateDecodingStrategy
                    
                    do {
                        let result = try jsonDecoder.decode(T.self, from: unwrappedData)
                        NetworkClient.executeCompletionOnMainThread {
                            completion(.success(result))
                        }
                    } catch let error {
                        NetworkClient.executeCompletionOnMainThread {
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    NetworkClient.executeCompletionOnMainThread {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
            return task
        } catch {
            NetworkClient.executeCompletionOnMainThread {
                completion(.failure(HTTPresponseErrors.badRequest))
            }
        }
        return nil
    }

//    @discardableResult
//    func makeRequest<T: Decodable>(
//        httpRequest: HTTPrequest,
//        completion: @escaping (Result<T, Error>) -> Void
//    ) -> Cancellable? {
//        do {
//            let urlRequest = try makeURLrequest(httpRequest: httpRequest)
//            
//            let task = urlSession.dataTask(with: urlRequest) { data, response, error in
//                
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//                guard let response = response as? HTTPURLResponse,
//                      let data = data
//                else {
//                    completion(.failure(NetworkClientErrors.failedRequest))
//                    return
//                }
//                print("Status code od request:", response.statusCode)
//                print("Get:", data)
//                let handleResponse = HTTPresponse.handleResponse(for: response)
//                switch handleResponse {
//                case .success:
//                    do {
//                        let jsonDecoder = JSONDecoder()
//                        let result = try jsonDecoder.decode(T.self, from: data)
//                        completion(.success(result))
//                    } catch {
//                        completion(.failure(error))
//                    }
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
//            task.resume()
//            return task
//        } catch {
//            completion(.failure(error))
//        }
//        return nil
//    }
    
    private static func executeCompletionOnMainThread(_ closure: @escaping () -> Void) {
        DispatchQueue.main.async {
            closure()
        }
    }
    
    private func makeURLrequest(httpRequest: HTTPrequest) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: httpRequest.route) else {
            throw NetworkClientErrors.failedMakingURLComponents
        }
        
        let queryItems = httpRequest.queryItems.map { queryItem in
            URLQueryItem(name: queryItem.key, value: queryItem.value)
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw NetworkClientErrors.failedMakingURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpRequest.method.rawValue
        urlRequest.httpBody = httpRequest.body
    
        for header in httpRequest.headers {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return urlRequest
    }
}

extension URLSessionDataTask: Cancellable {}
