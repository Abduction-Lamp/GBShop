//
//  LoginView.swift
//  GBShop
//
//  Created by Владимир on 20.12.2021.
//

import UIKit

final class LoginView: UIView {
    
    private let gradientLayer: CALayer = {
        let layer = CAGradientLayer()

        let begin: UIColor = .systemGreen
        let end: UIColor = .systemPurple

        layer.colors = [begin.cgColor, end.cgColor]
        layer.locations = [0 as NSNumber, 1 as NSNumber]
        layer.startPoint = CGPoint.zero
        layer.endPoint = CGPoint(x: 0, y: 1)

        return layer
    }()
    
    private(set) var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private(set) var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NewYork-Regular", size: 44)
        label.textColor = .black
        label.layer.masksToBounds = false
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = .zero
        label.layer.shadowOpacity = 0.7
        label.layer.shadowRadius = 10
        label.text = "Магазин"
        return label
    }()
    private let headerPadding = Padding<CGFloat>(top: 45, bottom: .zero, trailing: .zero, leading: .zero)
    private let headerSize = CGSize(width: .zero, height: 50)

    private(set) var loginTextField: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.font = UIFont(name: "NewYork-Regular", size: 17)
        textfield.autocapitalizationType = .none
        textfield.textAlignment = .center
        textfield.textColor = .black
        textfield.backgroundColor = .systemGray5
        textfield.borderStyle = .roundedRect
        textfield.placeholder = "Логин"
        return textfield
    }()
    
    private(set) var passwordTextField: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.font = UIFont(name: "NewYork-Regular", size: 17)
        textfield.isSecureTextEntry = true
        textfield.autocapitalizationType = .none
        textfield.textAlignment = .center
        textfield.textColor = .black
        textfield.backgroundColor = .systemGray5
        textfield.borderStyle = .roundedRect
        textfield.placeholder = "Пароль"
        return textfield
    }()
    private let textFieldSize = CGSize(width: 250, height: 40)
    
    private(set) var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemYellow
        button.setTitleColor(.systemGray2, for: .highlighted)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "NewYork-Regular", size: 17)
        button.layer.cornerRadius = 5
        button.setTitle("Войти", for: .normal)
        return button
    }()
    
    private(set) var registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemYellow
        button.setTitleColor(.systemGray2, for: .highlighted)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "NewYork-Regular", size: 17)
        button.layer.cornerRadius = 5
        button.setTitle("Регистрация", for: .normal)
        return button
    }()
    private let buttonSize = CGSize(width: 150, height: 40)
    private let registerButtonPadding = Padding<CGFloat>(top: .zero, bottom: 15, trailing: .zero, leading: .zero)
    
    private var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()
    
    // MARK: - Initialization
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Support methods
    //
    private func configuration() {
        self.layer.addSublayer(gradientLayer)
        gradientLayer.frame = self.bounds
        
        self.addSubview(scrollView)

        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerLabel)
        contentView.addSubview(stack)

        stack.addArrangedSubview(loginTextField)
        stack.addArrangedSubview(passwordTextField)
        stack.addArrangedSubview(loginButton)
        
        contentView.addSubview(registerButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            headerLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: headerPadding.top),
            headerLabel.heightAnchor.constraint(equalToConstant: headerSize.height),
            
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            loginTextField.widthAnchor.constraint(equalToConstant: textFieldSize.width),
            loginTextField.heightAnchor.constraint(equalToConstant: textFieldSize.height),

            passwordTextField.widthAnchor.constraint(equalToConstant: textFieldSize.width),
            passwordTextField.heightAnchor.constraint(equalToConstant: textFieldSize.height),

            loginButton.widthAnchor.constraint(equalToConstant: buttonSize.width),
            loginButton.heightAnchor.constraint(equalToConstant: buttonSize.height),

            registerButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            registerButton.widthAnchor.constraint(equalToConstant: buttonSize.width),
            registerButton.heightAnchor.constraint(equalToConstant: buttonSize.height),
            registerButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -registerButtonPadding.bottom)
        ])
    }
}
