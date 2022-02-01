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
    let cellPaddingForInsetGroupedStyle = UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: 16)
    
    // MARK: - SIZE
    //
    let textFieldSize = CGSize(width: .zero, height: 40)
    let buttonSize = CGSize(width: .zero, height: 40)
    
    // MARK: - MAKE DESING COMPONENTS
    //
    func makeTextFildView(placeholder: String, keyboardType: UIKeyboardType = .asciiCapable) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = mediumFont
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.textAlignment = .left
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.keyboardType = keyboardType
        textField.placeholder = placeholder
        textField.accessibilityIdentifier = placeholder
        return textField
    }
}
