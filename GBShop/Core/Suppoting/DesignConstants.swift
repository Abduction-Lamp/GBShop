//
//  DesignConstants.swift
//  GBShop
//
//  Created by Владимир on 29.12.2021.
//

import UIKit

struct DesignConstants {
    
    static let shared = DesignConstants()
    private init() {
        smallFont = font.withSize(smallFontSize)
        mediumFont = font.withSize(mediumFontSize)
        largeFont = font.withSize(largeFontSize)
    }
    
    // MARK: - FONT
    //
    let font = UIFont(name: "NewYork-Regular", size: UIFont.labelFontSize) ?? UIFont.systemFont(ofSize: UIFont.labelFontSize)
    
    let smallFontSize: CGFloat = 14
    let mediumFontSize: CGFloat = 17
    let largeFontSize: CGFloat = 21
    
    let smallFont: UIFont
    let mediumFont: UIFont
    let largeFont: UIFont

    let padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    let imagePadding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    // MARK: - PADDING
    //
    let textFieldPadding = UIEdgeInsets(top: 7, left: 40, bottom: 7, right: 40)
    
    // MARK: - SIZE
    //
    let textFieldSize = CGSize(width: .zero, height: 40)
    
    // MARK: - MAKE DESING COMPONENTS
    //
    func makeTextFildView(placeholder: String, keyboardType: UIKeyboardType = .asciiCapable) -> UITextField {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.font = mediumFont
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.clearButtonMode = .whileEditing
        textfield.textAlignment = .left
        textfield.textColor = .black
        textfield.backgroundColor = .white
        textfield.borderStyle = .roundedRect
        textfield.keyboardType = keyboardType
        textfield.placeholder = placeholder
        return textfield
    }
}
