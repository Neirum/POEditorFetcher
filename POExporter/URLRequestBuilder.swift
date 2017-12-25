//
//  URLRequestBuilder.swift
//  POExporter
//
//  Created by Stas Zherebkin on 12/1/17.
//  Copyright © 2017 prog. All rights reserved.
//

import Foundation

typealias FlatJson = [String: String]

final class URLRequestBuilder {
    
    class func poeApiRequest(with url: URL, params: FlatJson, method: RequestMethod) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if method == .post {
            request.httpBody = postRequestBodyString(from: params).data(using: String.Encoding.utf8)
        }
        return request
    }
    
}

private extension URLRequestBuilder {
    
    class func postRequestBodyString(from json: FlatJson) -> String {
        var postString = ""
        for item in json {
            postString += item.key + "=" + item.value
        }
        
        let paramsArr = json.map( { $0.key + "=" + $0.value } )
        for param in paramsArr {
            postString += param
            if param == paramsArr.last {
                postString += "&"
            }
        }
        return postString
    }
    
}
