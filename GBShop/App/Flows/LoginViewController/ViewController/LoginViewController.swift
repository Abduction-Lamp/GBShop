//
//  LoginViewController.swift
//  GBShop
//
//  Created by Владимир on 20.12.2021.
//

import UIKit

final class LoginViewController: UIViewController {
    
    private var loginView: LoginView {
        guard let view = self.view as? LoginView else {
            return LoginView(frame: self.view.frame)
        }
        return view
    }
    
    private let notification = NotificationCenter.default
    private lazy var keyboardHideGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
    
    var presenret: LoginViewPresenterProtocol?

    // MARK: - Lifecycle
    //
    override func loadView() {
        super.loadView()
        
        configurationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        notification.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        notification.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Configure Content
    //
    private func configurationView() {
        self.view = LoginView(frame: self.view.frame)
        self.navigationController?.isNavigationBarHidden = true
        
        loginView.scrollView.addGestureRecognizer(keyboardHideGesture)
        
        loginView.loginTextField.delegate = self
        loginView.passwordTextField.delegate = self
        
        loginView.loginButton.addTarget(self, action: #selector(pressedLoginButton), for: .touchUpInside)
        loginView.registrationButton.addTarget(self, action: #selector(pressedRegistrationButton), for: .touchUpInside)
        
        loginView.loginTextField.text = "Username"
        loginView.passwordTextField.text = "UserPassword"
    }
}

// MARK: - LoginView Protocol
//
extension LoginViewController: LoginViewProtocol {
    
    func showRequestErrorAlert(error: Error) {
        showAlert(message: error.localizedDescription, title: "error")
    }
    
    func showErrorAlert(message: String) {
        showAlert(message: message, title: "Ошибка")
    }
}

// MARK: - Keyboard Actions
//
extension LoginViewController {
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFram = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue) else {
                  return
        }
        var keyboardFramRect: CGRect = keyboardFram.cgRectValue
        keyboardFramRect = self.view.convert(keyboardFramRect, from: nil)
        var contentInset: UIEdgeInsets = loginView.scrollView.contentInset
        contentInset.bottom = keyboardFramRect.size.height
        loginView.scrollView.contentInset = contentInset
    }
    
    @objc
    private func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        loginView.scrollView.contentInset = contentInset
    }
    
    @objc
    private func keyboardHide(_ sender: Any?) {
        loginView.scrollView.endEditing(true)
        if let button = sender as? UIButton,
           button === loginView.loginButton {
            pressedLoginButton(button)
        }
    }
}

// MARK: - TextField Delegate
//
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.placeholder = ""
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === loginView.loginTextField {
            textField.placeholder = "Логин"
        } else {
            textField.placeholder = "Пароль"
        }
    }
}

// MARK: - Button Actions
//
extension LoginViewController {
    
    @objc
    private func pressedLoginButton(_ sender: UIButton) {
        guard let login = loginView.loginTextField.text,
              let password = loginView.passwordTextField.text,
              !login.isEmpty,
              !password.isEmpty else { return }
        presenret?.auth(login: login, password: password)
    }
    
    @objc
    private func pressedRegistrationButton(_ sender: UIButton) {
        presenret?.goToRegistrationView()
    }
}
