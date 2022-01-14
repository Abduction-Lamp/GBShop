//
//  CartViewController.swift
//  GBShop
//
//  Created by Владимир on 08.01.2022.
//

import UIKit

final class CartViewController: UITableViewController {
    
    var presenret: CartViewPresenterProtocol?
    
    private var heightForRowAt: CGFloat = .zero
    
    // MARK: - Lifecycle
    //
    override func loadView() {
        super.loadView()
        configurationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = makePriceString(price: presenret?.cart.totalPrice ?? 0)
    }
    
    // MARK: - Configure Content
    //
    private func configurationView() {
        self.view.backgroundColor = .systemGray6
        
        tableView.register(EmptyCartViewCell.self, forHeaderFooterViewReuseIdentifier: EmptyCartViewCell.reuseIdentifier)
        tableView.register(CartViewCell.self, forCellReuseIdentifier: CartViewCell.reuseIdentifier)
        
        configurationNavigationBar()
        
        let padding = DesignConstants.shared.imagePadding
        let largeFontLineHeight = ceil(DesignConstants.shared.largeFont.lineHeight)
        let mediumFontLineHeight = ceil(DesignConstants.shared.mediumFont.lineHeight)
        heightForRowAt = padding.top + largeFontLineHeight + DesignConstants.shared.padding.top + mediumFontLineHeight + padding.bottom
    }
    
    private func configurationNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
    
        let chevronLeftIcom = UIImage(systemName: "chevron.left")
        let back = UIBarButtonItem(image: chevronLeftIcom, style: .plain, target: self, action: #selector(pressedBackButton))

        self.navigationItem.leftBarButtonItem = back
    }
}

// MARK: - Extension UITableViewDelegate & UITableViewDataSource
//
extension CartViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenret?.cart.items.count ?? 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRowAt
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let count = presenret?.cart.items.count, count > 0 {
            return .zero
        }
        return 450
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartViewCell.reuseIdentifier) as? CartViewCell,
              let model = presenret?.cart.items else {
            return UITableViewCell()
        }
        
        if let urlString = model[indexPath.row].product.imageURL,
           let url = URL(string: urlString) {
            cell.image.kf.indicatorType = .activity
            cell.image.kf.setImage(with: url)
        }
        cell.titleLabel.text = model[indexPath.row].product.name
        cell.priceLabel.text = makePriceString(price: model[indexPath.row].product.price)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenret?.removeItemFromCart(index: indexPath.row)
        }
    }
    
    override  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: EmptyCartViewCell.reuseIdentifier)
                as? EmptyCartViewCell else {
                    return nil
                }
        return footer
    }
    
    // MARK: - Support methods
    //
    private func makePriceString(price: Double) -> String {
        var priceString = String(format: "%.0f", price)
        priceString += " \u{20BD}"
        return priceString
    }
}

// MARK: - Extension Button Actions
//
extension CartViewController {
    
    @objc
    private func pressedBackButton(_ sender: UIButton) {
        presenret?.backTo()
    }
}

// MARK: - CartView Protocol
//
extension CartViewController: CartViewProtocol {
    
    func showRequestErrorAlert(error: Error) {
        showAlert(message: error.localizedDescription, title: "error")
    }
    
    func showErrorAlert(message: String) {
        showAlert(message: message)
    }
    
    func updataCart() {
        self.tableView.reloadData()
        self.title = makePriceString(price: presenret?.cart.totalPrice ?? 0)
    }
}
