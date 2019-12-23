//
//  RequestProtocol.swift
//  UtilsKit
//
//  Created by RGMC on 18/10/2018.
//  Copyright © 2018 RGMC. All rights reserved.
//

import Foundation

public protocol RequestProtocol {
    var scheme: String {get}
    var host: String {get}
    var path: String {get}
    var method: RequestMethod {get}
    
    var headers: Headers? {get}
    var parameters: Parameters? {get}
    var encoding: Encoding {get}
    var authentification: AuthentificationProtocol? {get}
    
    var cacheKey: String? {get}
    var queue: DispatchQueue {get}
    var identifier: String? {get}
}

extension RequestProtocol {
    
    public var headers: Headers? { return nil }
    public var parameters: Parameters? { return nil }
    public var encoding: Encoding { return .url }
    public var authentification: AuthentificationProtocol? { return nil }
    
    public var cacheKey: String? { return nil }
    public var queue: DispatchQueue { return DispatchQueue.main }
    public var identifier: String? { return nil }
    
    public func responseData(completion: ((Result<NetworkResponse, Error>) -> Void)? = nil) {
        RequestManager.shared.request(self, result: { (result) in
            switch result {
            case .success(let response):
                if let cacheKey = self.cacheKey {
                    NetworkCache.shared.set(response.data, for: cacheKey)
                }
                completion?(result)
            case .failure(let error):
                if let cacheKey = self.cacheKey, let data = NetworkCache.shared.get(cacheKey) {
                    completion?(.success((statusCode: (error as? RequestError)?.statusCode, data: data)))
                } else {
                    completion?(result)
                }
                
            }
        })
    }
    
    public func send(completion: ((Result<Void, Error>) -> Void)? = nil) {
        self.responseData { (result) in
            switch result {
            case .success: completion?(.success(()))
            case .failure(let error): completion?(.failure(error))
            }
        }
    }
    
    public func download(at URL: URL,
                         completion: ((Result<Int, Error>) -> Void)? = nil,
                         progress: ((URLSessionDownloadTask)->())? = nil)
    {
        RequestManager.shared.download(at: URL, request: self, result: completion, progress: progress)
    }
}

extension RequestProtocol { 
    public func clearCache() {
        guard let cacheKey = self.cacheKey else { return }
        NetworkCache.shared.delete(cacheKey)
    }
}

