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
    
    private lazy var changeBarButtonItem = UIBarButtonItem(title: "Изменить",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(pressedСhangeButton))
    private lazy var saveBarButtonItem = UIBarButtonItem(title: "Сохранить",
                                                         style: .done,
                                                         target: self,
                                                         action: #selector(pressedSaveButton))
    private lazy var cancelBarButtonItem = UIBarButtonItem(title: "Отменить",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(pressedCancelButton))
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
        self.navigationItem.rightBarButtonItem = changeBarButtonItem
        
        saveBarButtonItem.tintColor = .systemRed
        
        userPageView.scrollView.addGestureRecognizer(keyboardHideGesture)
        
        userPageView.creditCardTextField.delegate = self
        
        userPageView.logoutButton.addTarget(self, action: #selector(pressedLogOutButton), for: .touchUpInside)
    }
}

// MARK: - Extension UserPageView Protocol
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
    
    func didChangeUserData() {
        self.navigationItem.rightBarButtonItem = changeBarButtonItem
        self.navigationItem.leftBarButtonItem = nil
        
        isEditingUserData = false
        enabledUserDataView(isEnable: isEditingUserData)
    }
}

// MARK: - Extension Button Actions
//
extension UserPageViewController {

    @objc
    private func pressedLogOutButton(_ sender: UIButton) {
        presenret?.logout()
    }
    
    @objc
    private func pressedСhangeButton(_ sender: UIBarButtonItem) {
        self.navigationItem.rightBarButtonItem = saveBarButtonItem
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem
        
        isEditingUserData = true
        enabledUserDataView(isEnable: isEditingUserData)
    }
    
    @objc
    private func pressedSaveButton(_ sender: UIBarButtonItem) {
        guard let firstName = userPageView.firstNameTextField.text,
              let lastName = userPageView.lastNameTextField.text,
              let email = userPageView.emailTextField.text,
              let creditCard = userPageView.creditCardTextField.text,
              let login = userPageView.loginTextField.text,
              let password = userPageView.passwordTextField.text else { return }
        
        let gender = userPageView.genderSegmentControl.selectedSegmentIndex
        presenret?.changeUserData(firstName: firstName,
                                  lastName: lastName,
                                  gender: gender,
                                  email: email,
                                  creditCard: creditCard,
                                  login: login,
                                  password: password)
    }
    
    @objc
    private func pressedCancelButton(_ sender: UIBarButtonItem) {
        self.navigationItem.rightBarButtonItem = changeBarButtonItem
        self.navigationItem.leftBarButtonItem = nil
        
        isEditingUserData = false
        enabledUserDataView(isEnable: isEditingUserData)
        presenret?.getUserData()
    }
    
    private func enabledUserDataView(isEnable: Bool) {
        userPageView.genderSegmentControl.isEnabled = isEnable
        
        enabledTextField(userPageView.firstNameTextField, isEnable: isEnable)
        enabledTextField(userPageView.lastNameTextField, isEnable: isEnable)
        enabledTextField(userPageView.emailTextField, isEnable: isEnable)
        enabledTextField(userPageView.creditCardTextField, isEnable: isEnable)
        enabledTextField(userPageView.loginTextField, isEnable: isEnable)
        enabledTextField(userPageView.passwordTextField, isEnable: isEnable)
    }
    
    private func enabledTextField(_ textField: UITextField, isEnable: Bool) {
        let font17 = UIFont(name: "NewYork-Regular", size: 17)
        let font20 = UIFont(name: "NewYork-Regular", size: 20)
        
        textField.isEnabled = isEnable
        textField.backgroundColor = isEnable ? .systemGray6 : .white
        textField.borderStyle = isEnable ? .roundedRect : .none
        textField.font = isEnable ? font17 : font20
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
        guard textField === userPageView.creditCardTextField,
              let chars = string.cString(using: .utf8) else { return false }
        return userPageView.creditCardTextField.formatter(chars)
    }
}
