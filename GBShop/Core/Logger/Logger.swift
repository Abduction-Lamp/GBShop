//
//  Logger.swift
//  GBShop
//
//  Created by Владимир on 22.12.2021.
//

import Foundation
import Firebase

struct LogMessage: ExpressibleByStringLiteral {

    let message: String
    
    init(stringLiteral value: String) {
        self.message = value
    }
}

extension LogMessage {
    
    static var funcStart: LogMessage { "-->" }
    static var funcEnd: LogMessage { "<--" }
    static var call: LogMessage { "--" }
}

func logging(_ logInstance: Any, file: String = #file, funcName: String = #function, line: Int = #line) {
    let logMessage = "\(funcName) \(line): \(logInstance)"
    print("\(Date()): \(logMessage)")
    Crashlytics.crashlytics().log("\(logMessage)")
}

func logging(_ logInstance: LogMessage, file: String = #file, funcName: String = #function, line: Int = #line) {
    logging(logInstance.message, funcName: funcName, line: line)
}
