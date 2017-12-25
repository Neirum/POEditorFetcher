//
//  ProjectModel.swift
//  POExporter
//
//  Created by Stas Zherebkin on 12/1/17.
//  Copyright © 2017 prog. All rights reserved.
//

import Foundation

struct ProjectModel: Decodable {
    let id: Int
    let name: String
    let created: String
}
