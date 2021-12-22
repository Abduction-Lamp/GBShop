//
//  UserView.swift
//  GBShop
//
//  Created by Владимир on 22.12.2021.
//

import UIKit

final class UserView: UIView {
    
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
        view.backgroundColor = .white
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NewYork-Regular", size: 21)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Регистрация"
        return label
    }()

    private(set) lazy var firstNameTextField: UITextField = {
        return makeTextFildView(placeholder: "Имя")
    }()

    private(set) lazy var lastNameTextField: UITextField = {
        return makeTextFildView(placeholder: "Фамилия")
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
        return makeTextFildView(placeholder: "Фамилия", keyboardType: .emailAddress)
    }()

    private(set) lazy var creditCardTextField: UITextField = {
        return makeTextFildView(placeholder: "Кредитная карта", keyboardType: .numberPad)
    }()

    private(set) lazy var loginTextField: UITextField = {
        return makeTextFildView(placeholder: "Логин")
    }()

    private(set) lazy var passwordTextField: UITextField = {
        return makeTextFildView(placeholder: "Пароль")
    }()
    
    private let textFieldSize = CGSize(width: .zero, height: 40)
    private let textFieldPadding = Padding<CGFloat>(top: 7, bottom: 7, leading: 40, trailing: 40)

    // MARK: - Initiation
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(firstNameTextField)
        contentView.addSubview(lastNameTextField)
        contentView.addSubview(genderSegmentControl)
        contentView.addSubview(emailTextField)
        contentView.addSubview(creditCardTextField)
        contentView.addSubview(loginTextField)
        contentView.addSubview(passwordTextField)

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

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: textFieldPadding.top * 2),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: textFieldSize.height),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: textFieldPadding.top * 2),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: textFieldSize.height),
            
            firstNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: textFieldPadding.top * 2),
            firstNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: textFieldPadding.leading),
            firstNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -textFieldPadding.trailing),
            firstNameTextField.heightAnchor.constraint(equalToConstant: textFieldSize.height),
            
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: textFieldPadding.top),
            lastNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: textFieldPadding.leading),
            lastNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -textFieldPadding.trailing),
            lastNameTextField.heightAnchor.constraint(equalToConstant: textFieldSize.height),
            
            genderSegmentControl.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: textFieldPadding.top * 2),
            genderSegmentControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: textFieldPadding.leading),
            genderSegmentControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -textFieldPadding.trailing),
            genderSegmentControl.heightAnchor.constraint(equalToConstant: textFieldSize.height),
            
            emailTextField.topAnchor.constraint(equalTo: genderSegmentControl.bottomAnchor, constant: textFieldPadding.top * 4),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: textFieldPadding.leading),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -textFieldPadding.trailing),
            emailTextField.heightAnchor.constraint(equalToConstant: textFieldSize.height),
            
            creditCardTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: textFieldPadding.top),
            creditCardTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: textFieldPadding.leading),
            creditCardTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -textFieldPadding.trailing),
            creditCardTextField.heightAnchor.constraint(equalToConstant: textFieldSize.height),
            
            loginTextField.topAnchor.constraint(equalTo: creditCardTextField.bottomAnchor, constant: textFieldPadding.top * 2),
            loginTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: textFieldPadding.leading),
            loginTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -textFieldPadding.trailing),
            loginTextField.heightAnchor.constraint(equalToConstant: textFieldSize.height),
            
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: textFieldPadding.top),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: textFieldPadding.leading),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -textFieldPadding.trailing),
            passwordTextField.heightAnchor.constraint(equalToConstant: textFieldSize.height)
        ])
    }
    
    // MARK: - Support methods
    //
    private func makeTextFildView(placeholder: String, keyboardType: UIKeyboardType = .default) -> UITextField {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.font = UIFont(name: "NewYork-Regular", size: 17)
        textfield.autocapitalizationType = .none
        textfield.clearButtonMode = .whileEditing
        textfield.textAlignment = .left
        textfield.textColor = .black
        textfield.backgroundColor = .white
        textfield.borderStyle = .none
        textfield.keyboardType = keyboardType
        textfield.placeholder = placeholder
        return textfield
    }
}
