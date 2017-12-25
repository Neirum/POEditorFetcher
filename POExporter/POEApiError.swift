//
//  POEError.swift
//  POExporter
//
//  Created by Stas Zherebkin on 12/1/17.
//  Copyright © 2017 prog. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

enum POEApiError: Error {
    
    case noInternetConnection
    case custom(String)
    case other
    
}

extension POEApiError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
            case .noInternetConnection:
                return "No internet connection"
            case .other:
                return "Something went wrong on server"
            case .custom(let message):
                return message
        }
    }
    
}

extension POEApiError {
    
    init(_ data: Data?) {
        guard
            let data = data,
            let fullResponse = try? JSONDecoder().decode(POEApiModel.self, from: data)
        else {
            self = .other
            return
        }
        self = .custom(fullResponse.response.message)
    }
    
}

