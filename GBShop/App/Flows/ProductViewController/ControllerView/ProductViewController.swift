//
//  ProductViewController.swift
//  GBShop
//
//  Created by Владимир on 28.12.2021.
//

import UIKit
import Kingfisher

final class ProductViewController: UITableViewController {
    
    private let notification = NotificationCenter.default
    private lazy var keyboardHideGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
    
    private var reviewThisProduct: String = ""
    private var rightBarButton = ButtonWithBadge(type: .system)
    
    var presenret: ProductViewPresenterProtocol?
    
    // MARK: - Lifecycle
    //
    override func loadView() {
        super.loadView()
        configurationView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.title = presenret?.product.category
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenret?.getCartIndicator()
        presenret?.fetchReview()
        notification.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        notification.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    // MARK: - Configure Content
    //
    private func configurationView() {
        self.view.backgroundColor = .systemGray6
        configurationNavigationBar()
        
        tableView.register(ProductViewCommentFormCell.self, forHeaderFooterViewReuseIdentifier: ProductViewCommentFormCell.reuseIdentifier)
        
        tableView.register(ProductViewTitleCell.self, forCellReuseIdentifier: ProductViewTitleCell.reuseIdentifier)
        tableView.register(ProductViewImageCell.self, forCellReuseIdentifier: ProductViewImageCell.reuseIdentifier)
        tableView.register(ProductViewDescriptionCell.self, forCellReuseIdentifier: ProductViewDescriptionCell.reuseIdentifier)
        tableView.register(ProductViewPriceCell.self, forCellReuseIdentifier: ProductViewPriceCell.reuseIdentifier)
        tableView.register(ProductViewCommentCell.self, forCellReuseIdentifier: ProductViewCommentCell.reuseIdentifier)
        
        tableView.addGestureRecognizer(keyboardHideGesture)
        
        tableView.separatorStyle = .none
        tableView.isEditing = false
        tableView.keyboardDismissMode = .interactive
    }
    
    private func configurationNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
    
        let cartIcon = UIImage(systemName: "cart")
        let chevronLeftIcon = UIImage(systemName: "chevron.left")
        
        rightBarButton.frame = CGRect(x: 0, y: 0, width: 27, height: 27)
        rightBarButton.setImage(cartIcon, for: .normal)
        rightBarButton.contentMode = .scaleToFill
        rightBarButton.addTarget(self, action: #selector(pressedCartButton), for: .touchUpInside)
        
        let back = UIBarButtonItem(image: chevronLeftIcon, style: .plain, target: self, action: #selector(pressedBackButton))
        let right = UIBarButtonItem(customView: rightBarButton)
        
        self.navigationItem.leftBarButtonItem = back
        self.navigationItem.rightBarButtonItem = right
    }
}

// MARK: - Extension UITableViewDelegate & UITableViewDataSource
//
extension ProductViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return presenret?.review.count ?? 0
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return getHeightForProductSection(tableView, heightForRowAt: indexPath)
        case 1:
            guard let reviewModel = presenret?.review, !reviewModel.isEmpty else { return .zero }
            return reviewModel[indexPath.row].height
        default:
            return .zero
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 200
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
    
    override  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 1:
            guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProductViewCommentFormCell.reuseIdentifier)
                    as? ProductViewCommentFormCell else {
                return nil
            }
            footer.form.delegate = self
            footer.addCommentButton.addTarget(self, action: #selector(pressedAddCommentButton), for: .touchUpInside)
            return footer
        default:
            return nil
        }
    }
    
    // MARK: - Support methods
    //
    private func getHeightForProductSection(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let productModel = self.presenret?.product else { return .zero }
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
            cell.titleLabel.text = presenret?.product.titleCell.value
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductViewImageCell.reuseIdentifier)
                    as? ProductViewImageCell else {
                return UITableViewCell()
            }
            cell.image.kf.indicatorType = .activity
            cell.image.kf.setImage(with: presenret?.product.imageCell.value)
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductViewDescriptionCell.reuseIdentifier)
                    as? ProductViewDescriptionCell else {
                return UITableViewCell()
            }
            cell.textView.text = presenret?.product.descriptionCell.value
            return cell
            
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductViewPriceCell.reuseIdentifier)
                    as? ProductViewPriceCell else {
                return UITableViewCell()
            }
            cell.priceButton.setTitle(presenret?.product.priceCell.value, for: .normal)
            cell.priceButton.addTarget(self, action: #selector(pressedPriceButton), for: .touchUpInside)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    private func getCellForReviewSection(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductViewCommentCell.reuseIdentifier)
                as? ProductViewCommentCell,
              let reviewModel = presenret?.review else {
            return UITableViewCell()
        }
        cell.username.text = reviewModel[indexPath.row].userLogin
        cell.date.text = reviewModel[indexPath.row].date
        cell.comment.text = reviewModel[indexPath.row].comment
        if reviewModel[indexPath.row].userLogin == presenret?.getUserInfo().login {
            cell.deleteButton.tag = reviewModel[indexPath.row].id
            cell.deleteButton.isHidden = false
            cell.deleteButton.addTarget(self, action: #selector(pressedDeleteCommentButton), for: .touchUpInside)
        }
        return cell
    }
}

// MARK: - TextView Delegate
//
extension ProductViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        reviewThisProduct = textView.text
    }
}

// MARK: - Extension Button Actions
//
extension ProductViewController {
    
    @objc
    private func pressedCartButton(_ sender: UIButton) {
        presenret?.goToCartView()
    }
    
    @objc
    private func pressedBackButton(_ sender: UIButton) {
        presenret?.backToCatalog()
    }
    
    @objc
    private func pressedPriceButton(_ sender: UIButton) {
        presenret?.addToCart()
    }
    
    @objc
    private func pressedAddCommentButton(_ sender: UIButton) {
        presenret?.addReview(reviewThisProduct)
        reviewThisProduct = ""
    }
    
    @objc
    private func pressedDeleteCommentButton(_ sender: UIButton) {
        presenret?.removeReview(id: sender.tag)
        reviewThisProduct = ""
    }
}

// MARK: - Extension Keyboard Actions
//
extension ProductViewController {
    
    @objc
    private func keyboardDidShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFram = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue) else { return }
        let keyboardFramRect: CGRect = keyboardFram.cgRectValue
        let yOffset = self.tableView.contentSize.height - self.tableView.bounds.size.height + keyboardFramRect.height
        self.tableView.setContentOffset(CGPoint(x: .zero, y: yOffset), animated: true)
    }
        
    @objc
    private func keyboardHide(_ sender: Any?) {
        self.tableView.endEditing(true)
    }
}

// MARK: - ProductView Protocol
//
extension ProductViewController: ProductViewProtocol {

    func showRequestErrorAlert(error: Error) {
        showAlert(message: error.localizedDescription, title: "error")
    }
    
    func showErrorAlert(message: String) {
        showAlert(message: message)
    }
    
    func setReviews() {
        self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
    }
    
    func updateCartIndicator(count: Int) {
        rightBarButton.update(badgeCount: count)
    }
}
