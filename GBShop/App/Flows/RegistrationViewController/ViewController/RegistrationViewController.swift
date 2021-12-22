//
//  RegistrationViewController.swift
//  GBShop
//
//  Created by Владимир on 21.12.2021.
//

import UIKit

final class RegistrationViewController: UIViewController {
    
    var presenret: RegistrationViewPresenterProtool?
    
    private let notifiction = NotificationCenter.default
    private lazy var keyboardHideGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
    
    private var registrationView: RegistrationView {
        guard let view = self.view as? RegistrationView else {
            return RegistrationView(frame: self.view.frame)
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
        
        notifiction.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notifiction.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        notifiction.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notifiction.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Configure Content
    //
    private func configurationView() {
        self.view = RegistrationView(frame: self.view.frame)
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Регистрация"
        
        registrationView.scrollView.addGestureRecognizer(keyboardHideGesture)
        
        registrationView.creditCardTextField.delegate = self
//        registrationView.lastNameTextField.delegate = self
//        registrationView.emailTextField.delegate = self
//        registrationView.passwordTextField.delegate = self
        
        registrationView.registrationButton.addTarget(self, action: #selector(pressedRegistrationButton), for: .touchUpInside)
    }
}

// MARK: - Extension RegistrationView Protocol
//
extension RegistrationViewController: RegistrationViewProtocol {
    
    func showRequestErrorAlert(error: Error) {
        showAlert(message: error.localizedDescription, title: "error")
    }
    
    func showErrorAlert(message: String) {
        showAlert(message: message, title: "Ошибка")
    }
}

// MARK: - Extension Button Actions
//
extension RegistrationViewController {
    
    @objc
    private func pressedRegistrationButton(_ sender: UIButton) {
        guard let firstName = registrationView.firstNameTextField.text,
              let lastName = registrationView.lastNameTextField.text,
              let email = registrationView.emailTextField.text,
              let creditCard = registrationView.creditCardTextField.text,
              let login = registrationView.loginTextField.text,
              let password = registrationView.passwordTextField.text else {
                  showAlert(message: "Не все поля заполнены")
                  return
              }
        let gender = registrationView.genderSegmentControl.selectedSegmentIndex
        presenret?.registration(firstName: firstName,
                                lastName: lastName,
                                gender: gender,
                                email: email,
                                creditCard: creditCard,
                                login: login,
                                password: password)
    }
}

// MARK: - Extension Keyboard Actions
//
extension RegistrationViewController {

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFram = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue) else {
                  return
        }
        var keyboardFramRect: CGRect = keyboardFram.cgRectValue
        keyboardFramRect = self.view.convert(keyboardFramRect, from: nil)
        var contentInset: UIEdgeInsets = registrationView.scrollView.contentInset
        contentInset.bottom = keyboardFramRect.size.height
        registrationView.scrollView.contentInset = contentInset
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        registrationView.scrollView.contentInset = contentInset
    }

    @objc
    private func keyboardHide(_ sender: Any?) {
        registrationView.scrollView.endEditing(true)
    }
}

// MARK: - TextField Delegate
//
extension RegistrationViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField === registrationView.creditCardTextField,
              let count = textField.text?.count,
              let char = string.cString(using: String.Encoding.utf8) else {
                  return false
              }
        
        let backSpace = strcmp(char, "\\b")
        if backSpace == -92 && count > 0 {
            textField.text?.removeLast()
            return false
        }
        
        switch count {
        case 0, 1, 2, 3, 5, 6, 7, 8, 10, 11, 12, 13, 15, 16, 17, 18: break
        case 4, 9, 14: textField.text?.append("-")
        default: return false
        }
        return true
    }
}
