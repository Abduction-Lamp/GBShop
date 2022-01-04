//
//  ReviewViewModel.swift
//  GBShop
//
//  Created by Владимир on 02.01.2022.
//

import UIKit

struct ReviewViewModel {
    let userLogin: String
    let comment: String
    let assessment: Int
    let date: String
    
    let height: CGFloat
    
    init(bounds: CGRect, userLogin: String, comment: String, assessment: Int, date: TimeInterval) {
        self.userLogin = userLogin
        self.comment = comment
        self.assessment = assessment
        
        let format = DateFormatter()
        format.timeZone = TimeZone(secondsFromGMT: 3)
        format.locale = Locale(identifier: "ru-RU")
        format.dateFormat = "dd MM YYYY"
        let dateOfComment = Date(timeIntervalSince1970: date)
        self.date = format.string(from: dateOfComment)
        
        let padding = DesignConstants.shared.padding
        let imagePadding = DesignConstants.shared.imagePadding
        let cellPadding = DesignConstants.shared.cellPaddingForInsetGroupedStyle
        let mediumFont = DesignConstants.shared.mediumFont
        let smallFont = DesignConstants.shared.smallFont
        
        let widthCell = bounds.width - cellPadding.left - cellPadding.right
        let width = widthCell - imagePadding.left - imagePadding.right
        
        let commentBlockSize = comment.calculationTextBlockSize(width: width, font: mediumFont)
        let heightTitleReviewComponent: CGFloat = padding.top + ceil(mediumFont.lineHeight)
        let heightDateReviewComponent: CGFloat = padding.top + ceil(smallFont.lineHeight)
        let heightCommentReviewComponent: CGFloat = imagePadding.top + commentBlockSize.height + imagePadding.bottom
        height = heightTitleReviewComponent + heightDateReviewComponent + heightCommentReviewComponent
    }
    
    init(bounds: CGRect, review: Review) {
        self.init(bounds: bounds,
                  userLogin: review.userLogin ?? "",
                  comment: review.comment ?? "",
                  assessment: review.assessment,
                  date: review.date)
    }
}

extension ReviewViewModel: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return  lhs.userLogin == rhs.userLogin &&
                lhs.comment == rhs.comment &&
                lhs.assessment == rhs.assessment &&
                lhs.date == rhs.date &&
                lhs.height == rhs.height
    }
}
