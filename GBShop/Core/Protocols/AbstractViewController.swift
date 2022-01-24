//
//  AbstractViewController.swift
//  GBShop
//
//  Created by Владимир on 22.12.2021.
//

import UIKit

protocol AbstractViewController: UIViewController {
    func showRequestErrorAlert(error: Error)
    func showErrorAlert(message: String)
    
    func showAlert(message: String, title: String?)
}

extension AbstractViewController {
    
    func showAlert(message: String, title: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let title = NSLocalizedString("General.Alert.CloseButton", comment: "")
        let action = UIAlertAction(title: title, style: .cancel, handler: nil)
        alert.addAction(action)
        alert.accessibilityLabel = "Alert"
        present(alert, animated: true, completion: nil)
    }
}
