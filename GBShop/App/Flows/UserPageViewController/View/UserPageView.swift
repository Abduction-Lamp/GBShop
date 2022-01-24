//
//  UserPageView.swift
//  GBShop
//
//  Created by Владимир on 22.12.2021.
//

import UIKit

final class UserPageView: UIView {
    
    private let design = DesignConstants.shared
    
    private(set) var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private(set) lazy var firstNameTextField: UITextField = {
        let placeholder = NSLocalizedString("UserPageView.FirstNameTextField.Placeholder", comment: "")
        return design.makeTextFildView(placeholder: placeholder)
    }()

    private(set) lazy var lastNameTextField: UITextField = {
        let placeholder = NSLocalizedString("UserPageView.LastNameTextField.Placeholder", comment: "")
        return design.makeTextFildView(placeholder: placeholder)
    }()
    
    private(set) var genderSegmentControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.backgroundColor = .systemBackground
        let maleTitle = NSLocalizedString("UserPageView.GenderSegmentControl.Title.0", comment: "")
        let femaleTitle = NSLocalizedString("UserPageView.GenderSegmentControl.Title.1", comment: "")
        segment.insertSegment(withTitle: maleTitle, at: 0, animated: false)
        segment.insertSegment(withTitle: femaleTitle, at: 1, animated: false)
        segment.selectedSegmentIndex = 0
        segment.isEnabled = false
        return segment
    }()
    
    private(set) lazy var emailTextField: UITextField = {
        let placeholder = NSLocalizedString("UserPageView.EmailTextField.Placeholder", comment: "")
        return design.makeTextFildView(placeholder: placeholder, keyboardType: .emailAddress)
    }()

    private(set) lazy var creditCardTextField: CreditCardTextField = {
        let textField = CreditCardTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = design.largeFont
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.textAlignment = .left
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.borderStyle = .none
        textField.isEnabled = false
        textField.keyboardType = .numberPad
        let placeholder = NSLocalizedString("UserPageView.CreditCardTextField.Placeholder", comment: "")
        textField.placeholder = placeholder
        textField.accessibilityIdentifier = placeholder
        return textField
    }()

    private(set) lazy var loginTextField: UITextField = {
        let placeholder = NSLocalizedString("UserPageView.LoginTextField.Placeholder", comment: "")
        return design.makeTextFildView(placeholder: placeholder)
    }()

    private(set) lazy var passwordTextField: UITextField = {
        let placeholder = NSLocalizedString("UserPageView.PasswordTextField.Placeholder", comment: "")
        let textField = design.makeTextFildView(placeholder: placeholder)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private(set) lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemYellow
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemGray2, for: .highlighted)
        button.titleLabel?.font = design.mediumFont
        button.layer.cornerRadius = 5
        let title = NSLocalizedString("UserPageView.LogoutButton.Title", comment: "")
        button.setTitle(title, for: .normal)
        button.accessibilityIdentifier = title
        return button
    }()
    private let buttonSize = CGSize(width: 100, height: 40)
    private let logoutButtonPadding = UIEdgeInsets(top: .zero, left: .zero, bottom: 15, right: .zero)

    // MARK: - Initialization
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure Content
    //
    private func configureContent() {
        self.backgroundColor = .systemGray6
        self.addSubview(scrollView)

        scrollView.addSubview(contentView)
        
        contentView.addSubview(firstNameTextField)
        contentView.addSubview(lastNameTextField)
        contentView.addSubview(genderSegmentControl)
        contentView.addSubview(emailTextField)
        contentView.addSubview(creditCardTextField)
        contentView.addSubview(loginTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(logoutButton)

        placesConstraint()
    }
    
    private func placesConstraint() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            firstNameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: design.textFieldPadding.top * 2),
            firstNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: design.textFieldPadding.left),
            firstNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -design.textFieldPadding.right),
            firstNameTextField.heightAnchor.constraint(equalToConstant: design.textFieldSize.height),
            
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: design.textFieldPadding.top),
            lastNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: design.textFieldPadding.left),
            lastNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -design.textFieldPadding.right),
            lastNameTextField.heightAnchor.constraint(equalToConstant: design.textFieldSize.height),
            
            genderSegmentControl.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: design.textFieldPadding.top * 2),
            genderSegmentControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: design.textFieldPadding.left),
            genderSegmentControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -design.textFieldPadding.right),
            genderSegmentControl.heightAnchor.constraint(equalToConstant: design.textFieldSize.height),
            
            emailTextField.topAnchor.constraint(equalTo: genderSegmentControl.bottomAnchor, constant: design.textFieldPadding.top * 4),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: design.textFieldPadding.left),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -design.textFieldPadding.right),
            emailTextField.heightAnchor.constraint(equalToConstant: design.textFieldSize.height),
            
            creditCardTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: design.textFieldPadding.top),
            creditCardTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: design.textFieldPadding.left),
            creditCardTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -design.textFieldPadding.right),
            creditCardTextField.heightAnchor.constraint(equalToConstant: design.textFieldSize.height),
            
            loginTextField.topAnchor.constraint(equalTo: creditCardTextField.bottomAnchor, constant: design.textFieldPadding.top * 2),
            loginTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: design.textFieldPadding.left),
            loginTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -design.textFieldPadding.right),
            loginTextField.heightAnchor.constraint(equalToConstant: design.textFieldSize.height),
            
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: design.textFieldPadding.top),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: design.textFieldPadding.left),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -design.textFieldPadding.right),
            passwordTextField.heightAnchor.constraint(equalToConstant: design.textFieldSize.height),
            
            logoutButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: buttonSize.width),
            logoutButton.heightAnchor.constraint(equalToConstant: buttonSize.height),
            logoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -logoutButtonPadding.bottom)
        ])
    }
}
