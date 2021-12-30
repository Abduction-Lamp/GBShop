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
    var model: ProductViewModel?

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
        self.view.backgroundColor = .systemGray6
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: nil)
        
        self.tableView.register(ProductViewTitleCell.self, forCellReuseIdentifier: ProductViewTitleCell.reuseIdentifier)
        self.tableView.register(ProductViewImageCell.self, forCellReuseIdentifier: ProductViewImageCell.reuseIdentifier)
        self.tableView.register(ProductViewDescriptionCell.self, forCellReuseIdentifier: ProductViewDescriptionCell.reuseIdentifier)
        self.tableView.register(ProductViewPriceCell.self, forCellReuseIdentifier: ProductViewPriceCell.reuseIdentifier)
        
        self.tableView.separatorStyle = .none
        self.tableView.isEditing = false
    }
}

extension ProductViewController: ProductViewProtocol {
    
    var bounds: CGRect {
        return UIScreen.main.bounds
    }
    
    func showRequestErrorAlert(error: Error) {
        showAlert(message: error.localizedDescription, title: "error")
    }
    
    func showErrorAlert(message: String) {
        showAlert(message: message, title: "Ошибка")
    }
    
    func setProduct(model: ProductViewModel) {
        self.model = model
        self.title = model.category
    }
    
    func setReview(id: Int) {
        return
    }
    
}

extension ProductViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return model?.titleCell.height ?? .zero
        case 1:
            return model?.imageCell.height ?? .zero
        case 2:
            return model?.descriptionCell.height ?? .zero
        case 3:
            return model?.priceCell.height ?? .zero

        default:
            return .zero
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductViewTitleCell.reuseIdentifier,
                                                           for: indexPath) as? ProductViewTitleCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = model?.titleCell.value
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductViewImageCell.reuseIdentifier,
                                                           for: indexPath) as? ProductViewImageCell else {
                return UITableViewCell()
            }
            cell.image.kf.indicatorType = .activity
            cell.image.kf.setImage(with: model?.imageCell.value)
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductViewDescriptionCell.reuseIdentifier,
                                                           for: indexPath) as? ProductViewDescriptionCell else {
                return UITableViewCell()
            }
            cell.textView.text = model?.descriptionCell.value
            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductViewPriceCell.reuseIdentifier,
                                                           for: indexPath) as? ProductViewPriceCell else {
                return UITableViewCell()
            }
            cell.priceLabel.text = model?.priceCell.value
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
