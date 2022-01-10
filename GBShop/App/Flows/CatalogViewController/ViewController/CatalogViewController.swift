//
//  CatalogViewController.swift
//  GBShop
//
//  Created by Владимир on 25.12.2021.
//

import UIKit
import Kingfisher

final class CatalogViewController: UICollectionViewController {
    
    private var cellSize = CGSize.zero
    private var rightBarButton = ButtonWithBadge(type: .system)

    var presenret: CatalogViewPresenterProtocol?
    
    // MARK: - Lifecycle
    //
    override func loadView() {
        super.loadView()
        configurationView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenret?.getCartCountItems()
    }
    
    // MARK: - Configure Content
    //
    private func configurationView() {
        configurationNavigationBar()
        
        self.collectionView.backgroundColor = .systemGray6
        self.collectionView.register(CatalogHeaderView.self,
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: CatalogHeaderView.reuseIdentifier)
        self.collectionView.register(CatalogViewCell.self, forCellWithReuseIdentifier: CatalogViewCell.reuseIdentifier)
        cellSize = calculationСellSize()
    }
    
    private func configurationNavigationBar() {
        self.title = "Магазин"
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let personIcon = UIImage(systemName: "person")
        let cartIcon = UIImage(systemName: "cart")
                
        rightBarButton.frame = CGRect(x: 0, y: 0, width: 27, height: 27)
        rightBarButton.setImage(cartIcon, for: .normal)
        rightBarButton.contentMode = .scaleToFill
        rightBarButton.addTarget(self, action: #selector(pressedCartButton), for: .touchUpInside)
        
        let left = UIBarButtonItem(image: personIcon, style: .plain, target: self, action: #selector(pressedUserPageButton))
        let right = UIBarButtonItem(customView: rightBarButton)
        
        self.navigationItem.leftBarButtonItem = left
        self.navigationItem.rightBarButtonItem = right
    }
    
    // MARK: - Support methods
    //
    private func makePriceString(price: Double) -> String {
        var priceString = String(format: "%.0f", price)
        priceString += " \u{20BD}"
        return priceString
    }
    
    private func calculationСellSize() -> CGSize {
        let desing = DesignConstants.shared
        let width: CGFloat = (collectionView.bounds.size.width - 21)/2
        let heightTitleComponent: CGFloat = desing.padding.top + desing.mediumFont.lineHeight
        let heightImageComponent: CGFloat = width
        let heightPriceComponent: CGFloat = desing.padding.top + desing.buttonSize.height + desing.padding.bottom
        let height: CGFloat = heightTitleComponent + heightImageComponent + heightPriceComponent
        return CGSize(width: width, height: height)
    }
}

extension CatalogViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return presenret?.catalog.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenret?.catalog[section].items.count ?? 0
    }
    
    override  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogViewCell.reuseIdentifier,
                                                            for: indexPath) as? CatalogViewCell,
              let catalog = presenret?.catalog else { return UICollectionViewCell() }
        
        cell.title.text = catalog[indexPath.section].items[indexPath.row].name
        cell.priceLabel.text = makePriceString(price: catalog[indexPath.section].items[indexPath.row].price)
        if let urlString = catalog[indexPath.section].items[indexPath.row].imageURL,
           let url = URL(string: urlString) {
            cell.imageView.kf.indicatorType = .activity
            cell.imageView.kf.setImage(with: url)
        }
        cell.buyButon.tag = catalog[indexPath.section].items[indexPath.row].id
        cell.buyButon.addTarget(self, action: #selector(pressedBuyButon), for: .touchUpInside)
        return cell
    }
        
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let section = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                            withReuseIdentifier: CatalogHeaderView.reuseIdentifier,
                                                                            for: indexPath) as? CatalogHeaderView,
              let catalog = presenret?.catalog else { return UICollectionReusableView() }
        
        section.title.text = catalog[indexPath.section].title
        return section
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = presenret?.catalog[indexPath.section].items[indexPath.row].id {
            presenret?.goToProductView(id: id)
        }
    }
}

extension CatalogViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 7, bottom: 1, right: 7)
    }
}

// MARK: - Extension Button Actions
//
extension CatalogViewController {
    
    @objc
    private func pressedCartButton(_ sender: UIButton) {
        presenret?.goToCartView()
    }
    
    @objc
    private func pressedUserPageButton(_ sender: UIBarButtonItem) {
        presenret?.goToUserPageView()
    }
    
    @objc
    private func pressedBuyButon(_ sender: UIButton) {
        presenret?.addToCart(productId: sender.tag)
    }
}

extension CatalogViewController: CatalogViewProtocol {
    
    func showRequestErrorAlert(error: Error) {
        showAlert(message: error.localizedDescription, title: "error")
    }
    
    func showErrorAlert(message: String) {
        showAlert(message: message, title: "Ошибка")
    }
    
    func setCatalog() {
        self.collectionView.reloadData()
    }
    
    func updateCartIndicator(count: Int) {
        rightBarButton.update(badgeCount: count)
    }
    
    func updateUserDataInPresenter(user: User, token: String) {
        presenret?.updateUserData(user: user, token: token)
    }
}
