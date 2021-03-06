//
//  UserPageViewController.swift
//  GBShop
//
//  Created by Владимир on 22.12.2021.
//

import UIKit

final class UserPageViewController: UIViewController {
    
    private let desing = DesignConstants.shared
    
    private var userPageView: UserPageView {
        guard let view = self.view as? UserPageView else {
            return UserPageView(frame: self.view.frame)
        }
        return view
    }
    
    private var spinner: LoadingScreenWithSpinner?
    
    private let notifiction = NotificationCenter.default
    private lazy var keyboardHideGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))

    private lazy var buckBarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        let title = NSLocalizedString("LoginView.HeaderLabel.Text", comment: "")
        button.setTitle(" " + title, for: .normal)
        button.tintColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        button.addTarget(self, action: #selector(pressedBackButton), for: .touchUpInside)
        button.sizeToFit()
        return button
    }()
    private lazy var changeBarButtonItem = UIBarButtonItem(
        title: NSLocalizedString("UserPageView.NavigationBar.ChangeBarButton", comment: ""),
        style: .plain,
        target: self,
        action: #selector(pressedСhangeButton))
    private lazy var saveBarButtonItem = UIBarButtonItem(
        title: NSLocalizedString("UserPageView.NavigationBar.SaveBarButton", comment: ""),
        style: .done,
        target: self,
        action: #selector(pressedSaveButton))
    private lazy var cancelBarButtonItem = UIBarButtonItem(
        title: NSLocalizedString("UserPageView.NavigationBar.CancelBarButton", comment: ""),
        style: .plain,
        target: self,
        action: #selector(pressedCancelButton))
    private lazy var buckBarButtonItem = UIBarButtonItem(customView: buckBarButton)
    
    private var isEditingUserData: Bool = false
    
    var presenret: UserPageViewPresenterProtocol?
    
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
        configurationNavigationBar()
        
        userPageView.scrollView.addGestureRecognizer(keyboardHideGesture)
        userPageView.creditCardTextField.delegate = self
        userPageView.logoutButton.addTarget(self, action: #selector(pressedLogOutButton), for: .touchUpInside)
        
        enabledUserDataView(isEnable: isEditingUserData)
        
        spinner = LoadingScreenWithSpinner(view: userPageView)
    }
    
    private func configurationNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.leftBarButtonItem = buckBarButtonItem
        self.navigationItem.rightBarButtonItem = changeBarButtonItem
        
        saveBarButtonItem.tintColor = .systemRed
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
        self.navigationItem.leftBarButtonItem = buckBarButtonItem
        self.navigationItem.rightBarButtonItem = changeBarButtonItem
    
        isEditingUserData = false
        enabledUserDataView(isEnable: isEditingUserData)
        
        presenret?.getUserData()
    }
    
    @objc
    private func pressedBackButton(_ sender: UIBarButtonItem) {
        presenret?.backToCatalog()
    }
    
    // MARK: Suppotr methods
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
        textField.isEnabled = isEnable
        textField.backgroundColor = isEnable ? .white : .systemGray6
        textField.borderStyle = isEnable ? .roundedRect : .none
        textField.font = isEnable ? desing.mediumFont : desing.largeFont
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

// MARK: - UserPageView Protocol
//
extension UserPageViewController: UserPageViewProtocol {
        
    func showRequestErrorAlert(error: Error) {
        let title = NSLocalizedString("General.Alert.Title", comment: "")
        showAlert(message: error.localizedDescription, title: title)
    }
    
    func showErrorAlert(message: String) {
        let title = NSLocalizedString("General.Alert.Title", comment: "")
        showAlert(message: message, title: title)
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
        self.navigationItem.leftBarButtonItem = buckBarButtonItem

        isEditingUserData = false
        enabledUserDataView(isEnable: isEditingUserData)
    }
    
    func showLoadingScreen() {
        spinner?.show()
    }
    
    func hideLoadingScreen() {
        spinner?.hide()
    }
}
