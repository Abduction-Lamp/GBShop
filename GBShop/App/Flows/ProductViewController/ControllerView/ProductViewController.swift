//
//  ProductViewController.swift
//  GBShop
//
//  Created by Владимир on 28.12.2021.
//

import UIKit
import Kingfisher

final class ProductViewController: UITableViewController {
    
    var presenret: ProductViewPresenterProtocol?
    
    // MARK: - Lifecycle
    //
    override func loadView() {
        super.loadView()
    
        configurationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configurationView() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        
        let cartIcon = UIImage(systemName: "cart")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: cartIcon,
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: nil)
    }
}

extension ProductViewController: ProductViewProtocol {
    
    func showRequestErrorAlert(error: Error) {
        showAlert(message: error.localizedDescription, title: "error")
    }
    
    func showErrorAlert(message: String) {
        showAlert(message: message, title: "Ошибка")
    }
    
    func setProduct(name: String, category: String, price: Double, description: String?, imageURL: URL?) {
        self.title = category
    }
    
    func setReview(id: Int) {
        return
    }
    
}
