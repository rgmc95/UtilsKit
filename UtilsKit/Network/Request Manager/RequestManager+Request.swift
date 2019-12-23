//
//  RequestManager+Request.swift
//  UtilsKit
//
//  Created by RGMC on 16/07/2019.
//  Copyright © 2019 RGMC. All rights reserved.
//

import Foundation

//MARK: - Request
extension RequestManager {
    
    private func request(
        scheme: String,
        host: String,
        path: String,
        method: RequestMethod = .get,
        parameters: Parameters? = nil,
        encoding: Encoding = .url,
        headers: Headers? = nil,
        authentification: AuthentificationProtocol? = nil,
        queue: DispatchQueue = DispatchQueue.main,
        identifier: String? = nil,
        completion: ((Result<NetworkResponse, Error>) -> Void)? = nil)
    {
        queue.async {
            var request: URLRequest
            
            do {
                request = try self.buildRequest(scheme: scheme,
                                                host: host,
                                                path: path,
                                                method: method,
                                                parameters: parameters,
                                                encoding: encoding,
                                                headers: headers,
                                                authentification: authentification)
            } catch let error {
                completion?(.failure(error))
                return
            }
            
            let _identifier = identifier ?? request.url?.absoluteString ?? ""
            
            let session = URLSession(configuration: self.requestConfiguration)
            
            if let timeoutInterval = self.requestTimeoutInterval {
                request.timeoutInterval = timeoutInterval
            }
            
            log(.network(method: method.rawValue, type: .sending), _identifier)
            
            session.dataTask(with: request, completionHandler: { (data, response, error) in
                queue.async {
                    guard let response = response as? HTTPURLResponse else {
                        completion?(.failure(ResponseError.unknow))
                        return
                    }
                    
                    if response.statusCode >= 200 && response.statusCode < 300 {
                        log(.network(method: method.rawValue, type: .success), _identifier)
                        completion?(.success((response.statusCode, data)))
                        return
                    } else {
                        let error = ResponseError.network(response: response)
                        log(.network(method: method.rawValue, type: .error), _identifier, error: error)
                        completion?(.failure(error))
                        return
                    }
                }
            }).resume()
        }
    }
    
    public func request(_ request: RequestProtocol,
                        result: ((Result<NetworkResponse, Error>) -> Void)? = nil) {
        self.request(scheme: request.scheme,
                     host: request.host,
                     path: request.path,
                     method: request.method,
                     parameters: request.parameters,
                     encoding: request.encoding,
                     headers: request.headers,
                     authentification: request.authentification,
                     queue: request.queue,
                     identifier: request.identifier,
                     completion: result)
    }
}
