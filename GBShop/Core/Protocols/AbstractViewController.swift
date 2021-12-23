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
        let action = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
