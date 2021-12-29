//
//  RegistrationView.swift
//  GBShop
//
//  Created by Владимир on 21.12.2021.
//

import UIKit

final class RegistrationView: UIView {
    
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
        return design.makeTextFildView(placeholder: "Имя")
    }()

    private(set) lazy var lastNameTextField: UITextField = {
        return design.makeTextFildView(placeholder: "Фамилия")
    }()
    
    private(set) var genderSegmentControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.backgroundColor = .systemBackground
        segment.insertSegment(withTitle: "Мужчина", at: 0, animated: false)
        segment.insertSegment(withTitle: "Женщина", at: 1, animated: false)
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    private(set) lazy var emailTextField: UITextField = {
        return design.makeTextFildView(placeholder: "E-mail", keyboardType: .emailAddress)
    }()

    private(set) lazy var creditCardTextField: CreditCardTextField = {
        let textfield = CreditCardTextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.font = design.mediumFont
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.clearButtonMode = .whileEditing
        textfield.textAlignment = .left
        textfield.textColor = .black
        textfield.backgroundColor = .white
        textfield.borderStyle = .roundedRect
        textfield.keyboardType = .numberPad
        textfield.placeholder = "Кредитная карта"
        return textfield
    }()

    private(set) lazy var loginTextField: UITextField = {
        return design.makeTextFildView(placeholder: "Логин")
    }()

    private(set) lazy var passwordTextField: UITextField = {
        let textField = design.makeTextFildView(placeholder: "Пароль")
        textField.isSecureTextEntry = false
        textField.textContentType = .init(rawValue: "")
        return textField
    }()
    
    private(set) lazy var registrationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemYellow
        button.setTitleColor(.systemGray2, for: .highlighted)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = design.mediumFont
        button.layer.cornerRadius = 5
        button.setTitle("Зарегистрироваться ", for: .normal)
        return button
    }()
    
    private let registrationButtonSize = CGSize(width: 200, height: 40)
    private let registrationButtonPadding = UIEdgeInsets(top: .zero, left: .zero, bottom: 15, right: .zero)

    override func layoutSubviews() {
        super.layoutSubviews()
        configureContent()
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
        contentView.addSubview(registrationButton)
        
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
            
            registrationButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            registrationButton.widthAnchor.constraint(equalToConstant: registrationButtonSize.width),
            registrationButton.heightAnchor.constraint(equalToConstant: registrationButtonSize.height),
            registrationButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -registrationButtonPadding.bottom)
        ])
    }
}
