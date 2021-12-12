//
//  ReviewResponse.swift
//  GBShop
//
//  Created by Владимир on 12.12.2021.
//

import Foundation

struct ReviewResponse: Codable {
    let result: Int
    let message: String
    let review: [Review]?
    
    var description: String {
        var output = """
                     result:   \(result)
                     message:  \(message)
                     
                     """
        if let review = self.review {
            let format = DateFormatter()
            format.timeZone = TimeZone(secondsFromGMT: 3)
            format.locale = Locale(identifier: "ru-RU")
            format.dateFormat = "EEEE, dd MMMM hh:mm"
            
            review.forEach { item in
                let date = Date(timeIntervalSince1970: item.date)
                output += """
                          review:   id:           \(item.id)
                                    product id:   \(item.productId)
                                    product name: \(item.productName)
                                    user id:      \(item.userId)
                                    user login:   \(item.userLogin)
                                    comment:      \(item.comment ?? "")
                                    assessment:   \(item.assessment)
                                    date:         \(format.string(from: date))
                          
                          """
            }
        }
        return output
    }
}
