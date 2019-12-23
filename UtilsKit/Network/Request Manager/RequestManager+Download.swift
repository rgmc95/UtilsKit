//
//  RequestManager+Download.swift
//  UtilsKit
//
//  Created by RGMC on 16/07/2019.
//  Copyright © 2019 RGMC. All rights reserved.
//

import Foundation

//MARK: - Download
extension RequestManager {
    
    private func downloadRequest(at URL: URL,
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
                                 completion: ((Result<Int, Error>) -> Void)? = nil,
                                 progress: ((URLSessionDownloadTask)->())? = nil) {
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
            
            let delegate = NetworkDownloadManagement(destination: URL, identifier: _identifier, completion: completion, progress: progress)
            let session = URLSession(configuration: self.downloadConfiguration, delegate: delegate, delegateQueue: nil)
            
            if let timeoutInterval = self.downloadTimeoutInterval {
                request.timeoutInterval = timeoutInterval
            }
            
            log(.network(method: method.rawValue, type: .sending), _identifier)
            
            session.downloadTask(with: request).resume()
        }
    }
    
    
    public func download(at URL: URL,
                         request: RequestProtocol,
                         result: ((Result<Int, Error>) -> Void)? = nil,
                         progress: ((URLSessionDownloadTask)->())? = nil) {
        self.downloadRequest(at: URL,
                             scheme: request.scheme,
                             host: request.host,
                             path: request.path,
                             method: request.method,
                             parameters: request.parameters,
                             encoding: request.encoding,
                             headers: request.headers,
                             authentification: request.authentification,
                             queue: request.queue,
                             identifier: request.identifier,
                             completion: result,
                             progress: progress)
    }
}

//MARK: - Network download management
private class NetworkDownloadManagement: NSObject, URLSessionDownloadDelegate {
    
    let destination: URL
    let identifier: String?
    let completion: ((Result<Int, Error>) -> Void)?
    let progress: ((URLSessionDownloadTask)->())?
    
    init(destination: URL, identifier: String?, completion: ((Result<Int, Error>) -> Void)?, progress: ((URLSessionDownloadTask)->())?) {
        self.destination = destination
        self.identifier = identifier
        self.completion = completion
        self.progress = progress
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let response = downloadTask.response as? HTTPURLResponse else {
            completion?(.failure(ResponseError.unknow))
            return
        }
        
        if response.statusCode >= 200 && response.statusCode < 300 {
            log(.network(method: downloadTask.originalRequest?.httpMethod ?? "", type: .success), identifier)
            
            do {
                try FileManager.default.moveItem(at: location, to: destination)
                completion?(.success(response.statusCode))
            } catch let error {
                completion?(.failure(error))
            }
            
            return
        } else {
            let error = ResponseError.network(response: response)
            log(.network(method: downloadTask.originalRequest?.httpMethod ?? "", type: .error), identifier, error: error)
            completion?(.failure(error))
            return
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error == nil { return }
        guard let response = task.response as? HTTPURLResponse else {
            completion?(.failure(ResponseError.unknow))
            return
        }
        
        let requestError = ResponseError.network(response: response)
        log(.network(method: task.originalRequest?.httpMethod ?? "", type: .error), identifier, error: requestError)
        completion?(.failure(requestError))
        return
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        progress?(downloadTask)
    }
}
