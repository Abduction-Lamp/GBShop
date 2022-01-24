//
//  LoginViewUITests.swift
//  GBShopUITests
//
//  Created by Владимир on 17.01.2022.
//

import XCTest

class LoginViewUITests: XCTestCase {
    
    func localizedString(key: String) -> String {
        guard let path = Bundle(for: LoginViewUITests.self).path(forResource: NSLocale.current.languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return ""
        }
        return NSLocalizedString(key, bundle: bundle, comment: "")
    }
    
    
    let app = XCUIApplication()
    
    var scrollView: XCUIElementQuery!
    var elementsQuery: XCUIElementQuery!
    
    var loginTextField: XCUIElement!
    var passwordTextField: XCUIElement!
    var loginButton: XCUIElement!
    var registrationButton: XCUIElement!
    
    var deleteKey: XCUIElement!
    
    let catalogViewPredicate = NSPredicate(format: "identifier == 'CatalogViewControllerCollectionView'")
    let registrationViewPredicate = NSPredicate(format: "identifier == 'RegistrationView'")
    let alertPredicate = NSPredicate(format: "label == 'Alert'")

    
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIApplication().launch()
        
        scrollView = app.scrollViews
        elementsQuery = scrollView.otherElements
        loginTextField = elementsQuery.textFields["loginTextField"].firstMatch
        passwordTextField = elementsQuery.secureTextFields["passwordTextField"].firstMatch
        loginButton = elementsQuery.buttons["loginButton"].firstMatch
        registrationButton = elementsQuery.buttons["registrationButton"].firstMatch
        
        deleteKey = app.keys["delete"]
    }

    override func tearDownWithError() throws {
        scrollView = nil
        elementsQuery = nil
        loginTextField = nil
        passwordTextField = nil
        loginButton = nil
        registrationButton = nil
        deleteKey = nil
    }
}


extension LoginViewUITests {
    
    func testLoginViewSuccess() throws {
        XCTAssert(loginTextField.exists)
        XCTAssert(passwordTextField.exists)
        XCTAssert(loginButton.exists)
        XCTAssert(registrationButton.exists)
        
        let identifierClearTextButton = localizedString(key: "General.TextField.ClearTextButton")
        loginTextField.tap()
        elementsQuery.buttons[identifierClearTextButton].tap()
        passwordTextField.tap()
        elementsQuery.buttons[identifierClearTextButton].tap()
        
        loginTextField.tap()
        app.typeText("Username")
        passwordTextField.tap()
        app.typeText("UserPassword")
        
        loginButton.tap()
        
        // Проверяем перешли ли в каталог
        let catalogView = app.descendants(matching: .collectionView)
                             .matching(catalogViewPredicate)
                             .element
        XCTAssertTrue(catalogView.waitForExistence(timeout: 5))
        XCTAssert(catalogView.exists)
    }

    func testLoginViewBadLogin() throws {
        XCTAssert(loginTextField.exists)
        XCTAssert(passwordTextField.exists)
        XCTAssert(loginButton.exists)
        XCTAssert(registrationButton.exists)
        
        let identifierClearTextButton = localizedString(key: "General.TextField.ClearTextButton")
        loginTextField.tap()
        elementsQuery.buttons[identifierClearTextButton].tap()
        passwordTextField.tap()
        elementsQuery.buttons[identifierClearTextButton].tap()
        
        loginTextField.tap()
        app.typeText("Login")
        passwordTextField.tap()
        app.typeText("UserPassword")
        
        loginButton.tap()

        // Проверяем появление Alert с сообщением о ошибках
        let identifierAlert = localizedString(key: "General.Alert.Title")
        let identifierCloseButton = localizedString(key: "General.Alert.CloseButton")
        let alert = app.alerts[identifierAlert]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: alert, handler: nil)
        waitForExpectations(timeout: 5) { _ in
            XCTAssert(alert.exists)
            alert.scrollViews.otherElements.buttons[identifierCloseButton].tap()
        }
    }
    
    func testGoToRegistrationView() throws {
        XCTAssert(registrationButton.exists)
        registrationButton.tap()
        
        // Проверяем перешли ли на страницу регистрации
        let registrationView = app.descendants(matching: .other)
                                  .matching(registrationViewPredicate)
                                  .element
        XCTAssertTrue(registrationView.waitForExistence(timeout: 1))
        XCTAssert(registrationView.exists)
    }
}
