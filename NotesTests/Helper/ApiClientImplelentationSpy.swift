//
//  ApiClientImplelentationSpy.swift
//  NotesTests
//
//  Created by Mike Haydan on 25/07/2018.
//  Copyright © 2018 Misha Apps. All rights reserved.
//

import Foundation

@testable import Notes

final class ApiClientImplelentationSpy: ApiClient {
    
    func executeWithDataTask<T>(request: URLRequest, completionHandler: @escaping (Result<ApiResponse<T>>) -> Void) -> URLSessionDataTask? where T : InitializableWithData {
        let dataTask = urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let httpUrlresponse = response as? HTTPURLResponse else {
                completionHandler(Result.failure(NetworkRequestError(error: error)))
                return
            }
            let successRange = 200...299
            if successRange.contains(httpUrlresponse.statusCode) {
                do {
                    let response = try ApiResponse<T>(data: data, httpUrlResponse: httpUrlresponse)
                    completionHandler(Result.success(response))
                } catch {
                    completionHandler(Result.failure(error))
                }
            } else {
                let apiError: HTTPError = HTTPError(statusCode: HTTPErrorCodes(statusCode: httpUrlresponse.statusCode), data: data)
                completionHandler(Result.failure(apiError))
            }
        })
        
        dataTask.resume()
        
        return dataTask
    }
    
    func printResponseDetails(httpUrlResponse: HTTPURLResponse) {
        if let urlString = httpUrlResponse.url?.absoluteString {
            let details: String = "| StatusCode: \(httpUrlResponse.statusCode) | Path: \(urlString) |"
            let line: String = String(repeating: "-", count: details.count)
            print(line)
            print(details)
            print(line)
        }
    }
    
    func cancelTasks() {
        urlSession.getAllTasks(completionHandler: { (tasks) in
            tasks.forEach({ $0.cancel() })
        })
    }
    
    typealias URLSessionCompletionHandlerResponse = (data: Data?, response: URLResponse?, error: Error?)
    
    private let urlSession: UrlSessionStub
    
    init() {
        let session = UrlSessionStub()
        urlSession = session
    }
    
    func set(response: URLSessionCompletionHandlerResponse) {
        urlSession.response.append(response)
    }
    
    func execute<T>(request: URLRequest, completionHandler completion: @escaping (_ result: Result<ApiResponse<T>>) -> ()) {
        _ = self.executeWithDataTask(request: request, completionHandler: completion)
    }
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: URL(string: "https://www.google.com")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
