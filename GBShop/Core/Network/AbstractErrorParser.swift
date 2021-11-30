//
//  AbstractErrorParser.swift
//  GBShop
//
//  Created by Владимир on 30.11.2021.
//

import Foundation

protocol AbstractErrorParser {
    func parse(_ result: Error) -> Error
    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error?
}
