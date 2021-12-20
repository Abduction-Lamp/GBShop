//
//  LoginViewController.swift
//  GBShop
//
//  Created by Владимир on 20.12.2021.
//

import UIKit

final class LoginViewController: UIViewController {
    
    var presenret: LoginViewPresenterProtool?
    
    private lazy var keyboardHideGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
    
    private var loginView: LoginView {
        guard let view = self.view as? LoginView else {
            return LoginView(frame: self.view.frame)
        }
        return view
    }
    
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
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    // MARK: - Support methods
    //
    private func configurationView() {
        self.view = LoginView(frame: self.view.frame)
        self.navigationController?.isNavigationBarHidden = true
        
        loginView.scrollView.addGestureRecognizer(keyboardHideGesture)
        
        loginView.loginTextField.delegate = self
        loginView.passwordTextField.delegate = self
    }
}

// MARK: - LoginView Protocol
//
extension LoginViewController: LoginViewProtocol {

}

// MARK: - Keyboard Actions
//
extension LoginViewController {
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
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
    func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        loginView.scrollView.contentInset = contentInset
    }
    
    @objc
    func keyboardHide() {
        loginView.scrollView.endEditing(true)
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
