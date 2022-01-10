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
        presenret?.fetchCart()
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
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        
        let back = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = back
    }
}

extension CartViewController: CartViewProtocol {
    
    func showRequestErrorAlert(error: Error) {
        showAlert(message: error.localizedDescription, title: "error")
    }
    
    func showErrorAlert(message: String) {
        showAlert(message: message)
    }
    
    func updataCart() {
        self.tableView.reloadData()
    }
}

extension CartViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenret?.cart.cart.count ?? 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRowAt
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let count = presenret?.cart.cart.count, count > 0 {
            return .zero
        }
        return 450
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartViewCell.reuseIdentifier) as? CartViewCell,
              let model = presenret?.cart.cart else {
            return UITableViewCell()
        }
        
        if let urlString = model[indexPath.row].imageURL,
           let url = URL(string: urlString) {
            cell.image.kf.indicatorType = .activity
            cell.image.kf.setImage(with: url)
        }
        cell.titleLabel.text = model[indexPath.row].name
        cell.priceLabel.text = makePriceString(price: model[indexPath.row].price)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenret?.removeFromCart(index: indexPath.row)
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
