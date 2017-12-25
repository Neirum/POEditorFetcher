//
//  POEApiClient.swift
//  POExporter
//
//  Created by Stas Zherebkin on 12/1/17.
//  Copyright © 2017 prog. All rights reserved.
//

import Foundation

import Foundation
import SystemConfiguration

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

final class POEApiClient {
    private var baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    @discardableResult
    func load(action: String, params: JSON, completion: @escaping(Data?, Error?) -> Void ) -> URLSessionDataTask? {
        guard Reachability.isConnectedToNetwork() else {
            completion(nil, POEApiError.noInternetConnection)
            return nil
        }
        guard let parameters = params as? FlatJson else {
            completion(nil, POEApiError.custom("Invalid json structure!"))
            return nil
        }
        /* Add token if it exists
         if let token = Preferences.getToken() {
         parameters["token"] = token
         }
         */
        let url = URL(baseUrl: baseUrl, path: action)
        let request = URLRequestBuilder.poeApiRequest(with:url, params: parameters, method: RequestMethod.post)
        return perform(request: request, completion: completion)
    }
}

private extension POEApiClient {
    
    func perform(request: URLRequest, completion: @escaping (Data?, Error?) -> Void ) -> URLSessionDataTask {
        // wrapping for calling callback in main thread
        let _completion: (Data?, Error?) -> Void = { result, error in
           // DispatchQueue.main.sync {
                completion(result, error)
            //}
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse, 200 == httpResponse.statusCode {
                _completion(data, nil)
            } else if let error = error {
                _completion(nil, error)
            } else {
                _completion(nil, POEApiError(data))
            }
        }
        task.resume()
        return task
    }
}
