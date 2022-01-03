//
//  ProductViewController.swift
//  GBShop
//
//  Created by Владимир on 28.12.2021.
//

import UIKit
import Kingfisher

final class ProductViewController: UITableViewController {
    
    var productModel: ProductViewModel?
    var reviewModel: [ReviewViewModel]? {
        didSet {
            self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }
    }
    
    var presenret: ProductViewPresenterProtocol?

    // MARK: - Lifecycle
    //
    override func loadView() {
        super.loadView()
        configurationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenret?.getReview()
    }
    
    // MARK: - Configure Content
    //
    private func configurationView() {
        self.view.backgroundColor = .systemGray6
        configurationNavigationBar()

        self.tableView.register(ProductViewTitleCell.self, forCellReuseIdentifier: ProductViewTitleCell.reuseIdentifier)
        self.tableView.register(ProductViewImageCell.self, forCellReuseIdentifier: ProductViewImageCell.reuseIdentifier)
        self.tableView.register(ProductViewDescriptionCell.self, forCellReuseIdentifier: ProductViewDescriptionCell.reuseIdentifier)
        self.tableView.register(ProductViewPriceCell.self, forCellReuseIdentifier: ProductViewPriceCell.reuseIdentifier)
        self.tableView.register(ProductViewCommentCell.self, forCellReuseIdentifier: ProductViewCommentCell.reuseIdentifier)
        
        self.tableView.separatorStyle = .none
        self.tableView.isEditing = false
    }
    
    private func configurationNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        
        let cartIcon = UIImage(systemName: "cart")
        
        let back = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let right = UIBarButtonItem(image: cartIcon, style: .plain, target: self, action: nil)
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = back
        self.navigationItem.rightBarButtonItem = right
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
        self.productModel = model
        self.title = model.category
    }
    
    func setReview(model: [ReviewViewModel]) {
        reviewModel = model
    }
}

extension ProductViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return reviewModel?.count ?? 0
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return getHeightForProductSection(tableView, heightForRowAt: indexPath)
        case 1:
            guard let reviewModel = self.reviewModel else { return .zero }
            return reviewModel[indexPath.row].height
        default:
            return .zero
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return getCellForProductSection(tableView, cellForRowAt: indexPath)
        case 1:
            return getCellForReviewSection(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - Support methods
    //
    private func getHeightForProductSection(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let productModel = self.productModel else { return .zero }
        switch indexPath.row {
        case 0:
            return productModel.titleCell.height
        case 1:
            return productModel.imageCell.height
        case 2:
            return productModel.descriptionCell.height
        case 3:
            return productModel.priceCell.height
        default:
            return .zero
        }
    }
    
    private func getCellForProductSection(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductViewTitleCell.reuseIdentifier)
                    as? ProductViewTitleCell else {
                return UITableViewCell()
            }
            cell.titleLabel.text = productModel?.titleCell.value
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductViewImageCell.reuseIdentifier)
                    as? ProductViewImageCell else {
                return UITableViewCell()
            }
            cell.image.kf.indicatorType = .activity
            cell.image.kf.setImage(with: productModel?.imageCell.value)
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductViewDescriptionCell.reuseIdentifier)
                    as? ProductViewDescriptionCell else {
                return UITableViewCell()
            }
            cell.textView.text = productModel?.descriptionCell.value
            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductViewPriceCell.reuseIdentifier)
                    as? ProductViewPriceCell else {
                return UITableViewCell()
            }
            cell.priceButton.setTitle(productModel?.priceCell.value, for: .normal)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    private func getCellForReviewSection(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductViewCommentCell.reuseIdentifier)
                as? ProductViewCommentCell else {
            return UITableViewCell()
        }
        cell.username.text = reviewModel?[indexPath.row].userLogin
        cell.date.text = reviewModel?[indexPath.row].date
        cell.comment.text = reviewModel?[indexPath.row].comment
        return cell
    }
}
