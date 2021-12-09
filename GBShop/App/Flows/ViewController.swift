//
//  ViewController.swift
//  GBShop
//
//  Created by Владимир on 27.11.2021.
//

import UIKit

class ViewController: UIViewController {

    private let request = RequestFactory()
//    private let user =
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        login(login: "Username", password: "UserPassword")
        logout(id: 1, token: "ED86EE70-124E-46DD-876B-4A4441F74575")
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
        let auth = request.makeAuthRequestFatory()
        auth.login(login: login, password: password) { response in
            switch response.result {
            case .success(let result):
                print("--- LOGIN RESULT: ---")
                print(result.description)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func logout(id: Int, token: String) {
        let auth = request.makeAuthRequestFatory()
        auth.logout(id: id, token: token) { response in
            switch response.result {
            case .success(let result):
                print("--- LOGOUT RESULT: ---")
                print(result.description)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func register(user: User, password: String) {
        let userRequest = request.makeUserRequestFactory()
        userRequest.register(user: user, password: password) { response in
            switch response.result {
            case .success(let result):
                print("--- USER REGISTER RESULT: ---")
                print(result)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func change(user: User, token: String) {
        let userRequest = request.makeUserRequestFactory()
        userRequest.change(user: user, token: token) { response in
            switch response.result {
            case .success(let result):
                print("--- USER DATA CHANGE RESULT: ---")
                print(result)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getCatalog(id: Int, page: Int) {
        let list = request.makeProductRequestFactory()
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
        let list = request.makeProductRequestFactory()
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
