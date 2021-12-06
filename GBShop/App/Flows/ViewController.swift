//
//  ViewController.swift
//  GBShop
//
//  Created by Владимир on 27.11.2021.
//

import UIKit

class ViewController: UIViewController {

    private let requestFactory = RequestFactory()
    private let user: Profile = Profile(id: 1,
                                        login: "Somebody",
                                        email: "Somebody@Somebody.ry",
                                        gender: "m",
                                        creditCard: "4000-1234-5678-0001",
                                        bio: "Все будет хорошо!")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        login(userName: "Somebody", password: "mypassword")
        logout(userName: "Somebody")
        register(user: user, password: "mypassword")
        change(user: user, password: "mypassword")
    }

 
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
    
    private func logout(userName: String) {
        let auth = requestFactory.makeAuthRequestFatory()
        auth.logout(userName: userName) { response in
            switch response.result {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func register(user: Profile, password: String) {
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
    
    private func change(user: Profile, password: String) {
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
}
