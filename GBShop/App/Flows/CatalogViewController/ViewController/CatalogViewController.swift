//
//  CatalogViewController.swift
//  GBShop
//
//  Created by Владимир on 25.12.2021.
//

import UIKit
import Kingfisher

final class CatalogViewController: UICollectionViewController {
    
    var presenret: CatalogViewPresenterProtocol?
    var catalog: [Section] = []
    
    var cellSize = CGSize.zero
    
    // MARK: - Lifecycle
    //
    override func loadView() {
        super.loadView()
    
        configurationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(pressedUserPageButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: nil)
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
        return catalog.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catalog[section].items.count
    }
    
    override  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogViewCell.reuseIdentifier,
                                                            for: indexPath) as? CatalogViewCell else { return UICollectionViewCell() }
        cell.title.text = catalog[indexPath.section].items[indexPath.row].name
        cell.priceLabel.text = makePriceString(price: catalog[indexPath.section].items[indexPath.row].price)
        if  let urlString = catalog[indexPath.section].items[indexPath.row].imageURL,
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
                                                                            for: indexPath) as? CatalogHeaderView else {
            return UICollectionReusableView()
        }
        section.title.text = catalog[indexPath.section].title
        return section
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenret?.product(id: catalog[indexPath.section].items[indexPath.row].id)
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
    private func pressedUserPageButton(_ sender: UIBarButtonItem) {
        presenret?.userPage()
    }
    
    @objc
    private func pressedBuyButon(_ sender: UIButton, id: Int) {
        presenret?.addCart(id: sender.tag)
    }
}

extension CatalogViewController: CatalogViewProtocol {
    
    func showRequestErrorAlert(error: Error) {
        showAlert(message: error.localizedDescription, title: "error")
    }
    
    func showErrorAlert(message: String) {
        showAlert(message: message, title: "Ошибка")
    }
    
    func setCatalog(_ catalog: [Section]) {
        self.catalog = catalog
        self.collectionView.reloadData()
    }
    
    func updataCart(count: Int) {
        (count < 1) ? (self.title = "Магазин") : (self.title = "В корзине [\(count)]")
    }
    
    func updataUserDataInPresenter(user: User, token: String) {
        presenret?.updataUserData(user: user, token: token)
    }
}
