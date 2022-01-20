//
//  String.swift
//  GBShop
//
//  Created by Владимир on 21.12.2021.
//

import UIKit

extension String {
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-zА-Яа-я._%+-]+@[A-Za-z0-9А-Яа-я.-]+\\.[A-Za-zА-Яа-я]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValidCreditCard() -> Bool {
        let cardRegEx = "[0-9]{4}+-[0-9]{4}+-[0-9]{4}+-[0-9]{4}"
        let cardPred = NSPredicate(format: "SELF MATCHES %@", cardRegEx)
        return cardPred.evaluate(with: self)
    }
    
    func calculationTextBlockSize(width: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        
        return CGSize(width: ceil(boundingBox.size.width),
                      height: ceil(boundingBox.size.height + font.lineHeight))
    }
}
