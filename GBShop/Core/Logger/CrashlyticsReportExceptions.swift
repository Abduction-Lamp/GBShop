//
//  CrashlyticsReportExceptions.swift
//  GBShop
//
//  Created by Владимир on 18.01.2022.
//

import Foundation
import Firebase

final class CrashlyticsReportExceptions {
    private(set) var domain: String = NSCocoaErrorDomain
    private(set) var code: Int?
    var userInfo: [String: Any]?
    
    public func report() {
        let error = NSError.init(domain: domain, code: code ?? -1000, userInfo: userInfo)
        Crashlytics.crashlytics().record(error: error)
    }
    
    public func report(code: Int) {
        let error = NSError.init(domain: domain, code: code, userInfo: userInfo)
        Crashlytics.crashlytics().record(error: error)
    }
    
    public func report(code: Int, info: [String: Any]?) {
        let error = NSError.init(domain: domain, code: code, userInfo: info)
        Crashlytics.crashlytics().record(error: error)
    }
    
    public func report(error: String) {
        let error = NSError.init(domain: domain, code: -1002, userInfo: ["error": error])
        Crashlytics.crashlytics().record(error: error)
    }
    
    public func report(error: NSError) {
        Crashlytics.crashlytics().record(error: error)
    }
}
