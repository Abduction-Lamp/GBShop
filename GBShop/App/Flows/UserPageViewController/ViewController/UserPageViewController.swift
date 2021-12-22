//
//  UserPageViewController.swift
//  GBShop
//
//  Created by Владимир on 22.12.2021.
//

import UIKit

final class UserPageViewController: UIViewController {
    
    var presenret: UserPageViewPresenterProtool?
    
    private let notifiction = NotificationCenter.default
    private lazy var keyboardHideGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
    
    private var userPageView: UserPageView {
        guard let view = self.view as? UserPageView else {
            return UserPageView(frame: self.view.frame)
        }
        return view
    }
    
    private var isEditingUserData: Bool = false

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
        self.view = UserPageView(frame: self.view.frame)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Изменить",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(pressedEditUserDataButton))
        
        userPageView.scrollView.addGestureRecognizer(keyboardHideGesture)
        
        userPageView.firstNameTextField.delegate = self
        userPageView.lastNameTextField.delegate = self
        userPageView.emailTextField.delegate = self
        userPageView.passwordTextField.delegate = self
        
        userPageView.logoutButton.addTarget(self, action: #selector(pressedLogOutButton), for: .touchUpInside)
    }
}

// MARK: - Extension RegistrationView Protocol
//
extension UserPageViewController: UserPageViewProtocol {
    
    func showRequestErrorAlert(error: Error) {
        showAlert(message: error.localizedDescription, title: "error")
    }
    
    func showErrorAlert(message: String) {
        showAlert(message: message, title: "Ошибка")
    }
    
    func setUserData(firstName: String, lastName: String, gender: Int, email: String, creditCard: String, login: String, password: String) {
        userPageView.firstNameTextField.text = firstName
        userPageView.lastNameTextField.text = lastName
        userPageView.genderSegmentControl.selectedSegmentIndex = gender
        userPageView.emailTextField.text = email
        userPageView.creditCardTextField.text = creditCard
        userPageView.loginTextField.text = login
        userPageView.passwordTextField.text = password
    }
}

// MARK: - Extension Button Actions
//
extension UserPageViewController {

    @objc
    private func pressedEditUserDataButton(_ sender: UIBarButtonItem) {
        if isEditingUserData {
            sender.style = .plain
            sender.title = "Изменить"
            sender.tintColor = .systemBlue
        } else {
            sender.style = .done
            sender.title = "Сохранить"
            sender.tintColor = .systemRed
        }
        isEditingUserData = !isEditingUserData
        isEnabledUserDataView(isEnable: isEditingUserData)
    }
    
    private func isEnabledUserDataView(isEnable: Bool) {
        userPageView.genderSegmentControl.isEnabled = isEnable
        
        isEnabledTextField(userPageView.firstNameTextField, isEnable: isEnable)
        isEnabledTextField(userPageView.lastNameTextField, isEnable: isEnable)
        isEnabledTextField(userPageView.emailTextField, isEnable: isEnable)
        isEnabledTextField(userPageView.creditCardTextField, isEnable: isEnable)
        isEnabledTextField(userPageView.loginTextField, isEnable: isEnable)
        isEnabledTextField(userPageView.passwordTextField, isEnable: isEnable)
    }
    
    private func isEnabledTextField(_ textField: UITextField, isEnable: Bool) {
        let font17 = UIFont(name: "NewYork-Regular", size: 17)
        let font21 = UIFont(name: "NewYork-Regular", size: 21)
        
        textField.isEnabled = isEnable
        textField.backgroundColor = isEnable ? .systemGray6 : .white
        textField.borderStyle = isEnable ? .roundedRect : .none
        textField.font = isEnable ? font17 : font21
    }
    
    @objc
    private func pressedLogOutButton(_ sender: UIButton) {
        presenret?.logout()
    }
}

// MARK: - Extension Keyboard Actions
//
extension UserPageViewController {

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFram = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue) else {
                  return
        }
        var keyboardFramRect: CGRect = keyboardFram.cgRectValue
        keyboardFramRect = self.view.convert(keyboardFramRect, from: nil)
        var contentInset: UIEdgeInsets = userPageView.scrollView.contentInset
        contentInset.bottom = keyboardFramRect.size.height
        userPageView.scrollView.contentInset = contentInset
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        userPageView.scrollView.contentInset = contentInset
    }

    @objc
    private func keyboardHide(_ sender: Any?) {
        userPageView.scrollView.endEditing(true)
    }
}

// MARK: - TextField Delegate
//
extension UserPageViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField === userPageView.passwordTextField else { return true}
        guard let count = textField.text?.count else { return false }
        switch count {
        case 0, 1, 2, 4, 5, 6, 7, 9, 10, 11, 12, 14, 15, 16, 17: break
        case 3, 8, 13: textField.text?.append("-")
        default: return false
        }
        return true
    }
}
