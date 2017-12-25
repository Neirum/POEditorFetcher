//
//  URL+Extension.swift
//  PokeBook
//
//  Created by user on 7/19/17.
//  Copyright © 2017 StasZherebkin. All rights reserved.
//

import Foundation

extension URL {
  
  init(baseUrl: String, path: String) {
    var componentsUrl = URLComponents.init(string: baseUrl)!
    componentsUrl.path += path
    self = componentsUrl.url!
  }
  
}
