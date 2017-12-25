//
//  LanguageModek.swift
//  POExporter
//
//  Created by Stas Zherebkin on 12/1/17.
//  Copyright © 2017 prog. All rights reserved.
//

import Foundation

struct LanguageModel: Decodable {
    let id: Int
    let code: String
    
    let updated: String
    let percentage: Int
    let translations: Int
}
