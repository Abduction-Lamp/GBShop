//
//  RegistrationViewUITests.swift
//  GBShopUITests
//
//  Created by Владимир on 17.01.2022.
//

import XCTest
import Alamofire
@testable import GBShop

class RegistrationViewUITests: XCTestCase {
    
    func localizedString(key: String) -> String {
        guard let path = Bundle(for: RegistrationViewUITests.self).path(forResource: NSLocale.current.languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return ""
        }
        return NSLocalizedString(key, bundle: bundle, comment: "")
    }

    let app = XCUIApplication()
    
    var registrationView: XCUIElement!
    var firstNameTextField: XCUIElement!
    var lastNameTextField: XCUIElement!
    var emailTextField: XCUIElement!
    var creditCardTextField: XCUIElement!
    var loginTextField: XCUIElement!
    var passwordTextField: XCUIElement!
    var registrationButton: XCUIElement!
    
    let registrationViewPredicate = NSPredicate(format: "identifier == 'RegistrationView'")
    let catalogViewPredicate = NSPredicate(format: "identifier == 'CatalogViewControllerCollectionView'")
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIApplication().launch()
        
        let loginScrollView = app.scrollViews
        let elementsQuery = loginScrollView.otherElements
//        var identifier = localizedString(key: "RegistrationView.RegistrationButton.Title")
        let button = elementsQuery.buttons["registrationButton"].firstMatch
        XCTAssert(button.exists)
        button.tap()
        
        // Проверяем перешли ли на страницу регистрации
        registrationView = app.descendants(matching: .other)
                              .matching(registrationViewPredicate)
                              .element
        XCTAssertTrue(registrationView.waitForExistence(timeout: 1))
        XCTAssert(registrationView.exists)
        
        var identifier = localizedString(key: "RegistrationView.FirstNameTextField.Placeholder")
        firstNameTextField = registrationView.textFields[identifier].firstMatch
        
        identifier = localizedString(key: "RegistrationView.LastNameTextField.Placeholder")
        lastNameTextField = registrationView.textFields[identifier].firstMatch
        
        identifier = localizedString(key: "RegistrationView.EmailTextField.Placeholder")
        emailTextField = registrationView.textFields[identifier].firstMatch
        
        identifier = localizedString(key: "RegistrationView.CreditCardTextField.Placeholder")
        creditCardTextField = registrationView.textFields[identifier].firstMatch
        
        identifier = localizedString(key: "RegistrationView.LoginTextField.Placeholder")
        loginTextField = registrationView.textFields[identifier].firstMatch
        
        identifier = localizedString(key: "RegistrationView.PasswordTextField.Placeholder")
        passwordTextField = registrationView.textFields[identifier].firstMatch
        
        identifier = localizedString(key: "RegistrationView.RegistrationButton.Title")
        registrationButton = registrationView.buttons[identifier].firstMatch
    }

    override func tearDownWithError() throws {
        registrationView = nil
        
        firstNameTextField = nil
        lastNameTextField = nil
        emailTextField = nil
        creditCardTextField = nil
        loginTextField = nil
        passwordTextField = nil
        registrationButton = nil
    }

    
    // MARK: - SUPPORT: Сбрасывает мок-данные на сервере в исходное состояние
    private func initialStateServer() {
        AF.request("https://salty-springs-77873.herokuapp.com/mock/server/state/initial")
            .responseJSON { response in
                switch response.result {
                case .success(let jsonObject):
                    if let json = jsonObject as? [String: Any] {
                        print(String(describing: "\n - [ INITIAL STATE MOCK SERVER ]: \(json["message"] ?? "nil")"))
                    } else {
                        XCTFail("server has not returned to its initial state")
                    }
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            }
    }
}

extension RegistrationViewUITests {
    
    func testRegistrationViewSuccess() throws {
        XCTAssert(firstNameTextField.exists)
        XCTAssert(lastNameTextField.exists)
        XCTAssert(emailTextField.exists)
        XCTAssert(creditCardTextField.exists)
        XCTAssert(loginTextField.exists)
        XCTAssert(passwordTextField.exists)
        XCTAssert(registrationButton.exists)
        
        initialStateServer()
        wait(for: [], timeout: 5)
        
        firstNameTextField.tap()
        app.typeText("TestFirstName")
        lastNameTextField.tap()
        app.typeText("TestLastName")
        emailTextField.tap()
        app.typeText("test@test.test")
        creditCardTextField.tap()
        app.typeText("11112222333344445555")
        loginTextField.tap()
        app.typeText("test")
        passwordTextField.tap()
        app.typeText("123456789")
        
        app.tap()
        registrationButton.tap()
        
        // Проверяем перешли ли в каталог
        let catalogView = app.descendants(matching: .collectionView)
                             .matching(catalogViewPredicate)
                             .element
        XCTAssertTrue(catalogView.waitForExistence(timeout: 10))
        XCTAssert(catalogView.exists)
    }
    
    func testRegistrationViewEmpty() throws {
        XCTAssert(firstNameTextField.exists)
        XCTAssert(lastNameTextField.exists)
        XCTAssert(emailTextField.exists)
        XCTAssert(creditCardTextField.exists)
        XCTAssert(loginTextField.exists)
        XCTAssert(passwordTextField.exists)
        XCTAssert(registrationButton.exists)

        registrationButton.tap()
                
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
}
