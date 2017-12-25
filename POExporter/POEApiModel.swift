//
//  POEApiModel.swift
//  POExporter
//
//  Created by Stas Zherebkin on 12/1/17.
//  Copyright © 2017 prog. All rights reserved.
//

import Foundation

struct POEApiModel: Decodable {
    
    struct POEResponseModel: Decodable {
        let status: String
        let code: String
        let message: String
    }
    
    let response: POEResponseModel
    let result: Data?
    
    
//    private enum ApiModelKeys: String, CodingKey {
//        case response
//        case result
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: ApiModelKeys.self)
//        response = try container.decode(POEResponseModel.self, forKey: .response)
//        result = try container.decode([String: Any].self, forKey: .result)
//    }
}



