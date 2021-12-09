//
//  ViewController.swift
//  GBShop
//
//  Created by Владимир on 27.11.2021.
//

import UIKit

class ViewController: UIViewController {

    private let requestFactory = RequestFactory()
    private let user: User = User(id: 1, login: "ssa", firstName: "sadsd", lastName: "sdasd", email: "asdasd", gender: "asdasd", creditCard: "asdasd")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        login(login: "Somebody", password: "mypassword")
        logout(id: 123, token: "sdsd")
//        register(user: user, password: "mypassword")
//        change(user: user, password: "mypassword")
//        getCatalog(id: 1, page: 1)
//        getGoodById(id: 123)
    }
}


//  MARK: - Network Service
//
extension ViewController {
    
    private func login(login: String, password: String) {
        let auth = requestFactory.makeAuthRequestFatory()
        auth.login(login: login, password: password) { response in
            switch response.result {
            case .success(let result):
                print("--- LOGIN RESULT: ---")
                print("result: \(result.result)")
                print("message: \(result.message)")
                print("token: \(result.token)")
                print("user: \(result.user)")
                print("\n")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func logout(id: Int, token: String) {
        let auth = requestFactory.makeAuthRequestFatory()
        auth.logout(id: id, token: token) { response in
            switch response.result {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func register(user: User, password: String) {
        let profile = requestFactory.makeUserRequestFactory()
        profile.change(user: user, password: password) { response in
            switch response.result {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func change(user: User, password: String) {
        let profile = requestFactory.makeUserRequestFactory()
        profile.register(user: user, password: password) { response in
            switch response.result {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getCatalog(id: Int, page: Int) {
        let list = requestFactory.makeProductRequestFactory()
        list.getCatalog(id: id, page: page) { response in
            switch response.result {
            case .success(let catalog):
                print(catalog)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getGoodById(id: Int) {
        let list = requestFactory.makeProductRequestFactory()
        list.getGoodById(id: id) { response in
            switch response.result {
            case .success(let product):
                print(product)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
