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
        
        let design = DesignConstants.shared
        let width = bounds.width - design.cellPaddingForInsetGroupedStyle.left - design.cellPaddingForInsetGroupedStyle.right
        
        let commentBlockSize = comment.calculationTextBlockSize(width: width - design.padding.left - design.padding.right,
                                                                font: design.mediumFont)
        let heightTitleReviewComponent: CGFloat = design.padding.top + ceil(design.mediumFont.lineHeight)
        let heightDateReviewComponent: CGFloat = design.padding.top + ceil(design.smallFont.lineHeight)
        let heightCommentReviewComponent: CGFloat = design.imagePadding.top + commentBlockSize.height + design.imagePadding.bottom
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
