//
//  RegistrationViewController.swift
//  GBShop
//
//  Created by Владимир on 21.12.2021.
//

import UIKit

final class RegistrationViewController: UIViewController {
    
    private var registrationView: RegistrationView {
        guard let view = self.view as? RegistrationView else {
            return RegistrationView(frame: self.view.frame)
        }
        return view
    }
    private var spinner: LoadingScreenWithSpinner?
    
    private let notifiction = NotificationCenter.default
    private lazy var keyboardHideGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
    
    var presenret: RegistrationViewPresenterProtocol?

    // MARK: - Lifecycle
    //
    override func loadView() {
        super.loadView()
        configurationView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        notifiction.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notifiction.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        notifiction.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notifiction.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Configure Content
    //
    private func configurationView() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.view = RegistrationView(frame: self.view.frame)
        self.navigationController?.isNavigationBarHidden = false
        self.title = NSLocalizedString("RegistrationView.NavigationBar.Title", comment: "")
        
        registrationView.scrollView.addGestureRecognizer(keyboardHideGesture)
        registrationView.creditCardTextField.delegate = self
        registrationView.registrationButton.addTarget(self, action: #selector(pressedRegistrationButton), for: .touchUpInside)
        
        spinner = LoadingScreenWithSpinner(view: registrationView)
    }
}

// MARK: - TextField Delegate
//
extension RegistrationViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField === registrationView.creditCardTextField,
              let chars = string.cString(using: .utf8) else { return false }
        return registrationView.creditCardTextField.formatter(chars)
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
                  let message = NSLocalizedString("General.Alert.EmptyFields", comment: "")
                  showAlert(message: message)
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

// MARK: - RegistrationView Protocol
//
extension RegistrationViewController: RegistrationViewProtocol {
    
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
