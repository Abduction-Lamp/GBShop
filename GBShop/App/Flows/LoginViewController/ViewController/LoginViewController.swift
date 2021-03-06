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
    private var spinner: LoadingScreenWithSpinner?
    
    private let notification = NotificationCenter.default
    private lazy var keyboardHideGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
    
    var presenret: LoginViewPresenterProtocol?

    // MARK: - Lifecycle
    //
    override func loadView() {
        super.loadView()
        configurationView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
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
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = true
        self.view = LoginView(frame: self.view.frame)

        loginView.scrollView.addGestureRecognizer(keyboardHideGesture)
        
        loginView.loginTextField.delegate = self
        loginView.passwordTextField.delegate = self
        
        loginView.loginButton.addTarget(self, action: #selector(pressedLoginButton), for: .touchUpInside)
        loginView.registrationButton.addTarget(self, action: #selector(pressedRegistrationButton), for: .touchUpInside)
        
        loginView.loginTextField.text = "Username"
        loginView.passwordTextField.text = "UserPassword"

        spinner = LoadingScreenWithSpinner(view: loginView)
    }
}

// MARK: - Extension TextField Delegate
//
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.placeholder = ""
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === loginView.loginTextField {
            textField.placeholder = NSLocalizedString("LoginView.LoginTextField.Placeholder", comment: "")
        } else {
            textField.placeholder = NSLocalizedString("LoginView.PasswordTextField.Placeholder", comment: "")
        }
    }
}

// MARK: - Extension Button Actions
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

// MARK: - Extension Keyboard Actions
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
        loginView.scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc
    private func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        loginView.scrollView.contentInset = contentInset
        loginView.scrollView.scrollIndicatorInsets = contentInset
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

// MARK: - LoginView Protocol
//
extension LoginViewController: LoginViewProtocol {

    func showRequestErrorAlert(error: Error) {
        let title = NSLocalizedString("General.Alert.Title", comment: "")
        showAlert(message: error.localizedDescription, title: title)
    }
    
    func showErrorAlert(message: String) {
        let title = NSLocalizedString("General.Alert.Title", comment: "")
        showAlert(message: message, title: title)
    }
    
    func showLoadingScreen() {
        spinner?.show()
    }
    
    func hideLoadingScreen() {
        spinner?.hide()
    }
}
