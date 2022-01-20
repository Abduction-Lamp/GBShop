//
//  MockNavigation.swift
//  GBShopTests
//
//  Created by Владимир on 23.12.2021.
//

import Foundation
import UIKit
@testable import GBShop

class MockNavigation: UINavigationController {
    
    var presentedVC: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.presentedVC = viewController
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        self.presentedVC = viewController
        return super.popToViewController(viewController, animated: animated)
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let initVC = super.popToRootViewController(animated: animated)
        self.presentedVC = initVC?.first
        return initVC
    }
}
