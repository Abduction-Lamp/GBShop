//
//  ViewController.swift
//  GBShop
//
//  Created by Владимир on 27.11.2021.
//

import UIKit

class ViewController: UIViewController {

    private let request = RequestFactory()
    private let user = User(id: 3,
                            login: "King",
                            firstName: "Дима",
                            lastName: "Сидоров",
                            email: "sidorov@mail.ru",
                            gender: "m",
                            creditCard: "9876-5432-1000-0000")
    
    let userChangeData = User(id: 2,
                              login: "Queen",
                              firstName: "Маша",
                              lastName: "Петрова",
                              email: "petrova@mail.ru",
                              gender: "w",
                              creditCard: "5555-6666-7777-8888")
    let tokenForChange = "13AA24D9-ECF1-401A-8F32-B05EBC7E8E38"
    let newReview = Review(id: 0,
                           productId: 1,
                           productName: nil,
                           userId: 2,
                           userLogin: nil,
                           comment: "test",
                           assessment: 5,
                           date: Date().timeIntervalSince1970)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        login(login: "Username", password: "UserPassword")
        logout(id: 1, token: "ED86EE70-124E-46DD-876B-4A4441F74575")
        register(user: user, password: "mypassword")
        change(user: userChangeData, token: tokenForChange)
        getProduct(id: 1)
        getCatalog(id: 2, page: 1)
        reviewByProduct(id: 1)
        reviewByUser(id: 2)
        reviewAdd(newReview, token: tokenForChange)
        reviewDelete(id: 11, userId: 2, token: tokenForChange)
    }
}


//  MARK: - Working with network
//
extension ViewController {
    
    private func login(login: String, password: String) {
        let auth = request.makeAuthRequestFatory()
        auth.login(login: login, password: password) { response in
            switch response.result {
            case .success(let result):
                print("--- LOGIN RESULT: ---\n\(result.description)")
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
                print("--- LOGOUT RESULT: ---\n\(result.description)")
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
                print("--- USER REGISTER RESULT: ---\n\(result.description)")
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
                print("--- USER DATA CHANGE RESULT: ---\n\(result.description)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getCatalog(id: Int, page: Int) {
        let catalog = request.makeProductRequestFactory()
        catalog.getCatalog(id: id, page: page) { response in
            switch response.result {
            case .success(let result):
                print("--- CATALOG ID=\(id) RESULT: ---\n\(result.description)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getProduct(id: Int) {
        let product = request.makeProductRequestFactory()
        product.getProduct(id: id) { response in
            switch response.result {
            case .success(let result):
                print("--- PRODUCT RESULT: ---\n\(result.description)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func reviewByProduct(id: Int) {
        let review = request.makeReviewRequestFactory()
        review.reviewByProduct(id: id) { response in
            switch response.result {
            case .success(let result):
                print("--- REVIEW BY PRODUCT RESULT: ---\n\(result.description)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func reviewByUser(id: Int) {
        let review = request.makeReviewRequestFactory()
        review.reviewByUser(id: id) { response in
            switch response.result {
            case .success(let result):
                print("--- REVIEW BY USER RESULT: ---\n\(result.description)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func reviewAdd(_ new: Review, token: String) {
        let review = request.makeReviewRequestFactory()
        review.reviewAdd(review: new, token: token) { response in
            switch response.result {
            case .success(let result):
                print("--- ADD NEW REVIEW RESULT: ---\n\(result.description)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func reviewDelete(id: Int, userId: Int, token: String) {
        let review = request.makeReviewRequestFactory()
        review.reviewDelete(reviewId: id, userId: userId, token: token) { response in
            switch response.result {
            case .success(let result):
                print("--- DELETE REVIEW RESULT: ---\n\(result.description)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
