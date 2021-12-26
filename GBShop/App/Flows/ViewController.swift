//
//  ViewController.swift
//  GBShop
//
//  Created by Владимир on 27.11.2021.
//

import UIKit

class ViewController: UIViewController {

    private let request = RequestFactory()
    
    // MARK: - Stubs
    //
    private let tokenToId1 = "ED86EE70-124E-46DD-876B-4A4441F74575"
    private let tokenToId2 = "13AA24D9-ECF1-401A-8F32-B05EBC7E8E38"
    
    private let newUser = User(id: 3,
                               firstName: "King",
                               lastName: "Дима",
                               gender: "Сидоров",
                               email: "sidorov@mail.ru",
                               creditCard: "m",
                               login: "9876-5432-1000-0000",
                               password: "qwertyuiop")
    
    private let userDataChange = User(id: 2,
                                      firstName: "Queen",
                                      lastName: "Маша",
                                      gender: "Петрова",
                                      email: "petrova@mail.ru",
                                      creditCard: "w",
                                      login: "5555-6666-7777-8888",
                                      password: "UserPassword")
    
    private let newReview = Review(id: 0,
                                   productId: 1,
                                   productName: nil,
                                   userId: 2,
                                   userLogin: nil,
                                   comment: "test",
                                   assessment: 5,
                                   date: Date().timeIntervalSince1970)

    // MARK: - Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBrown
        
//        login(login: "Username", password: "UserPassword")
//        logout(id: 1, token: tokenToId1)
//        register(user: newUser)
//        change(user: userDataChange, token: tokenToId2)
//        getProduct(id: 1)
//        getCatalog(id: 2, page: 1)
//        reviewByProduct(id: 1)
//        reviewByUser(id: 2)
//        reviewAdd(newReview, token: tokenToId2)
//        reviewDelete(id: 2, userId: 2, token: tokenToId2)
        
        productAddToCart(productId: 1, owner: 1, token: tokenToId1)
        productAddToCart(productId: 4, owner: 1, token: tokenToId1)
        
        cart(owner: 1, token: tokenToId1)
        
        productDeleteFromCart(productId: 1, owner: 1, token: tokenToId1)

        pay(owner: 1, token: tokenToId1)
    }
}

// MARK: - Working with network
//
extension ViewController {
    
    private func login(login: String, password: String) {
        let auth = request.makeAuthRequestFactory()
        auth.login(login: login, password: password) { response in
            switch response.result {
            case .success(let result):
                print("--- LOGIN RESULT: ---\n\(result)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func logout(id: Int, token: String) {
        let auth = request.makeAuthRequestFactory()
        auth.logout(id: id, token: token) { response in
            switch response.result {
            case .success(let result):
                print("--- LOGOUT RESULT: ---\n\(result)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func register(user: User) {
        let userRequest = request.makeUserRequestFactory()
        userRequest.register(user: user) { response in
            switch response.result {
            case .success(let result):
                print("--- USER REGISTER RESULT: ---\n\(result)")
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
                print("--- USER DATA CHANGE RESULT: ---\n\(result)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func getCatalog(id: Int, page: Int) {
        let catalog = request.makeProductRequestFactory()
        catalog.getCatalog(page: page) { response in
            switch response.result {
            case .success(let result):
                print("--- CATALOG ID=\(id) RESULT: ---\n\(result)")
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
                print("--- PRODUCT RESULT: ---\n\(result)")
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
                print("--- REVIEW BY PRODUCT RESULT: ---\n\(result)")
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
                print("--- REVIEW BY USER RESULT: ---\n\(result)")
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
                print("--- ADD NEW REVIEW RESULT: ---\n\(result)")
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
                print("--- DELETE REVIEW RESULT: ---\n\(result)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func cart(owner: Int, token: String) {
        let cart = request.makeCartRequestFactory()
        cart.cart(owner: owner, token: token) { response in
            switch response.result {
            case .success(let result):
                print("--- USER ID = \(owner) SHOPPING CART RESULT: ---\n\(result)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func productAddToCart(productId: Int, owner: Int, token: String) {
        let cart = request.makeCartRequestFactory()
        cart.add(productId: productId, owner: owner, token: token) { response in
            switch response.result {
            case .success(let result):
                print("--- ADD'S PRODUCT TO CART RESULT: ---\n\(result)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func productDeleteFromCart(productId: Int, owner: Int, token: String) {
        let cart = request.makeCartRequestFactory()
        cart.delete(productId: productId, owner: owner, token: token) { response in
            switch response.result {
            case .success(let result):
                print("--- DELETE'S PRODUCT FROM CART RESULT: ---\n\(result)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func pay(owner: Int, token: String) {
        let cart = request.makeCartRequestFactory()
        cart.pay(owner: owner, token: token) { response in
            switch response.result {
            case .success(let result):
                print("--- PAY RESULT: ---\n\(result)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
