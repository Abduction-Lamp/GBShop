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
        
        login(userName: "Somebody", password: "mypassword")
        logout(userID: 123, token: "sdsd")
//        register(user: user, password: "mypassword")
//        change(user: user, password: "mypassword")
//        getCatalog(id: 1, page: 1)
//        getGoodById(id: 123)
    }
}


//  MARK: - Network Service
//
extension ViewController {
    
    private func login(userName: String, password: String) {
        let auth = requestFactory.makeAuthRequestFatory()
        auth.login(userName: userName, password: password) { response in
            switch response.result {
            case .success(let login):
                print(login)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func logout(userID: Int, token: String) {
        let auth = requestFactory.makeAuthRequestFatory()
        auth.logout(userID: userID, token: token) { response in
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
