//
//  RequestFactory.swift
//  GBShop
//
//  Created by Владимир on 30.11.2021.
//

import Foundation
import Alamofire

class RequestFactory {

    func makeErrorParser() -> AbstractErrorParser {
        return ErrorParser()
    }
    
    lazy var commonSession: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        configuration.headers = .default
        let manager = Session(configuration: configuration)
        return manager
    }()

    let sessionQueue = DispatchQueue.global(qos: .utility)

    func makeAuthRequestFatory() -> AuthRequestFactory {
        let errorParser = makeErrorParser()
        return AuthRequest(errorParser: errorParser, sessionManager: commonSession, queue: sessionQueue)
    }

    func makeUserRequestFactory() -> UserRequestFactory {
        let errorParser = makeErrorParser()
        return UserRequest(errorParser: errorParser, sessionManager: commonSession, queue: sessionQueue)
    }

    func makeProductRequestFactory() -> ProductRequestFactory {
        let errorParser = makeErrorParser()
        return ProductRequest(errorParser: errorParser, sessionManager: commonSession, queue: sessionQueue)
    }

    func makeReviewRequestFactory() -> ReviewRequestFactory {
        let errorParser = makeErrorParser()
        return ReviewRequest(errorParser: errorParser, sessionManager: commonSession, queue: sessionQueue)
    }
}
