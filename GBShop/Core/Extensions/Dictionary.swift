//
//  Dictionary.swift
//  GBShop
//
//  Created by Владимир on 19.01.2022.
//

import Foundation

extension Dictionary {
    
    mutating func merge(dict: [Key: Value]) {
        for (key, value) in dict {
            self.updateValue(value, forKey: key)
        }
    }
}
