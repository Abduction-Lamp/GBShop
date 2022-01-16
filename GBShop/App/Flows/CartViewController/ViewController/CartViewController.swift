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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - Configure Content
    //
    private func configurationView() {
        self.view.backgroundColor = .systemGray6
        
        tableView.register(CartViewToolsFooter.self, forHeaderFooterViewReuseIdentifier: CartViewToolsFooter.reuseIdentifier)
        tableView.register(EmptyCartViewCell.self, forHeaderFooterViewReuseIdentifier: EmptyCartViewCell.reuseIdentifier)
        tableView.register(CartViewCell.self, forCellReuseIdentifier: CartViewCell.reuseIdentifier)
        
        tableView.separatorStyle = .none
        
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
        if let count = presenret?.cart.items.count, count > 0 {
            return count
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = presenret?.cart.items.count, count > 0 {
            return 1
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRowAt
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let count = presenret?.cart.items.count, count > 0 {
            return 40
        }
        return 450
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartViewCell.reuseIdentifier) as? CartViewCell,
              let model = presenret?.cart.items else {
            return UITableViewCell()
        }
        
        if let urlString = model[indexPath.section].product.imageURL,
           let url = URL(string: urlString) {
            cell.image.kf.indicatorType = .activity
            cell.image.kf.setImage(with: url)
        }
        cell.titleLabel.text = model[indexPath.section].product.name
        cell.priceLabel.text = makePriceString(price: model[indexPath.section].product.price)
        cell.multiplierLabel.text = "\u{00D7} \(model[indexPath.section].quantity)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let message = "Вы уверены, что хотите удалить \(presenret?.cart.items[indexPath.section].product.name ?? "")"
        warningWithAction(title: nil, message: message) { _ in
            if editingStyle == .delete {
                self.presenret?.removeItemFromCart(index: indexPath.section)
            }
        }
    }
        
    override  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let count = presenret?.cart.items.count, count > 0 {
            guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: CartViewToolsFooter.reuseIdentifier)
                    as? CartViewToolsFooter else {
                        return nil
                    }
            footer.deleteButton.tag = section
            footer.deleteButton.addTarget(self, action: #selector(pressedDeleteButton), for: .touchUpInside)
            
            footer.minusButton.tag = section
            footer.minusButton.addTarget(self, action: #selector(pressedMinusButton), for: .touchUpInside)
            if let quantity = presenret?.cart.items[section].quantity,
               quantity <= 1 {
                footer.minusButton.isEnabled = false
            } else {
                footer.minusButton.isEnabled = true
            }
            footer.plusButton.tag = section
            footer.plusButton.addTarget(self, action: #selector(pressedPlusButton), for: .touchUpInside)
            if let quantity = presenret?.cart.items[section].quantity,
               quantity > 50 {
                footer.plusButton.isEnabled = false
            } else {
                footer.plusButton.isEnabled = true
            }
            return footer
        } else {
            guard let footerEmpty = tableView.dequeueReusableHeaderFooterView(withIdentifier: EmptyCartViewCell.reuseIdentifier)
                    as? EmptyCartViewCell else {
                        return nil
                    }
            return footerEmpty
        }
    }
    
    // MARK: - Support methods
    //
    private func makePriceString(price: Double) -> String {
        var priceString = String(format: "%.0f", price)
        priceString += " \u{20BD}"
        return priceString
    }
    
    private func warningWithAction(title: String?, message: String?, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel) { _ in })
        alertController.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: handler))
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Extension Button Actions
//
extension CartViewController {
    
    @objc
    private func pressedBackButton(_ sender: UIButton) {
        presenret?.backTo()
    }
    
    @objc
    private func pressedDeleteButton(_ sender: UIButton) {
        let message = "Вы уверены, что хотите удалить все \(presenret?.cart.items[sender.tag].product.name ?? "")"
        warningWithAction(title: nil, message: message) { _ in
            self.presenret?.removeItemFromCart(index: sender.tag)
        }
    }
    
    @objc
    private func pressedMinusButton(_ sender: UIButton) {
        presenret?.removeProductFromCart(index: sender.tag)
    }
    
    @objc
    private func pressedPlusButton(_ sender: UIButton) {
        presenret?.addProductToCart(index: sender.tag)
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
    
    func updataCart(index: Int) {
        self.tableView.reloadSections(IndexSet(integer: index), with: .automatic)
        self.title = makePriceString(price: presenret?.cart.totalPrice ?? 0)
    }
}
