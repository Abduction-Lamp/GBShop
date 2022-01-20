//
//  FakeData.swift
//  GBShopTests
//
//  Created by Владимир on 03.01.2022.
//

import UIKit
@testable import GBShop

final class FakeData {
    
    let user = User(id: 3, firstName: "firstName", lastName: "lastName", gender: "m",
                    email: "email@email.ru", creditCard: "1111-1111-1111-1111",
                    login: "login", password: "password")

    
    let token = "ED86EE70-124E-46DD-876B-4A4441F74575"
    
    let product = Product(id: 1,
                          name: "MacBook Pro",
                          category: "Ноутбук",
                          price: 250_000,
                          description: "Экран 16 дюймов, Apple M1 Pro, 16 ГБ объединённой памяти, SSD‑накопитель 1 ТБ",
                          imageURL: nil)
    
    let product2 = Product(id: 2,
                          name: "MacBook Pro",
                          category: "Ноутбук",
                          price: 250_000,
                          description: "Экран 16 дюймов, Apple M1 Pro, 16 ГБ объединённой памяти, SSD‑накопитель 1 ТБ",
                          imageURL: nil)
    
    
    let catalog: [Section] = [
        Section(id: 1, title: "Ноутбук", items: [
            Product(id: 1,
                    name: "MacBook Pro",
                    category: "Ноутбук",
                    price: 250_000,
                    description: "Экран 16 дюймов, Apple M1 Pro, 16 ГБ объединённой памяти, SSD‑накопитель 1 ТБ",
                    imageURL: nil),
            Product(id: 2,
                    name: "Microsoft Surface Laptop",
                    category: "Ноутбук",
                    price: 130_000,
                    description: "Экран 13.5 дюймов, Core i5, 8GB, SSD‑накопитель 512GB",
                    imageURL: nil)
        ]),
        Section(id: 2, title: "Игровая приставка", items: [
            Product(id: 3,
                    name: "PlayStation 5",
                    category: "Игровая приставка",
                    price: 90_003,
                    description: "825 ГБ SSD, белый",
                    imageURL: nil),
            Product(id: 4,
                    name: "PlayStation 4 Slim",
                    category: "Игровая приставка",
                    price: 44_500,
                    description: "500 ГБ HDD, черный",
                    imageURL: nil),
            Product(id: 5,
                    name: "XBox Series X",
                    category: "Игровая приставка",
                    price: 69_770,
                    description: "1000 ГБ SSD, черный",
                    imageURL: nil)
        ])
    ]
    
    let reviewByProduct: [Review] = [
        Review(id: 3,
               productId: 1,
               productName: "MacBook Pro",
               userId: 1,
               userLogin: "Username",
               comment: "Не смотря на цену это лучший ноутбук!",
               assessment: 5,
               date: 1637940128.926343),
        Review(id: 5,
               productId: 1,
               productName: "MacBook Pro",
               userId: 2,
               userLogin: "Queen",
               comment: "Красивый и мощный",
               assessment: 5,
               date: 1638112928.926343),
        Review(id: 9,
               productId: 1,
               productName: "MacBook Pro",
               userId: 1,
               userLogin: "Username",
               comment: "Классно что вернули MagSafe",
               assessment: 5,
               date: 1638458528.926343),
        Review(id: 10,
               productId: 1,
               productName: "MacBook Pro",
               userId: 1,
               userLogin: "Username",
               comment: "И убрали тачбар",
               assessment: 5,
               date: 1638458528.926343)
    ]
    
    let reviewByUser: [Review] = [
        Review(id: 2,
               productId: 3,
               productName: "PlayStation 5",
               userId: 2,
               userLogin: "Queen",
               comment: "Неоправданно дорого",
               assessment: 2,
               date: 1637853728.926343),
        Review(id: 4,
               productId: 5,
               productName: "XBox Series X",
               userId: 2,
               userLogin: "Queen",
               comment: "Холодильник какой-то, но выглядит лучше чем PS5",
               assessment: 3,
               date: 1638112928.926343),
        Review(id: 5,
               productId: 1,
               productName: "MacBook Pro",
               userId: 2,
               userLogin: "Queen",
               comment: "Красивый и мощный",
               assessment: 5,
               date: 1638112928.926343),
        Review(id: 8,
               productId: 2,
               productName: "Microsoft Surface Laptop",
               userId: 2,
               userLogin: "Queen",
               comment: "И у меня такой, езжу с ним в универ, очень нравиться",
               assessment: 5,
               date: 1638372128.926343),
    ]
    
    lazy var reviewByProductViewModel: [ReviewViewModel] = reviewByProduct.map { ReviewViewModel(bounds: CGRect(x: 0, y: 0, width: 500, height: 100), review: $0) }
    lazy var reviewByUserViewModel: [ReviewViewModel] = reviewByUser.map { ReviewViewModel(bounds: CGRect(x: 0, y: 0, width: 500, height: 100), review: $0) }
}
