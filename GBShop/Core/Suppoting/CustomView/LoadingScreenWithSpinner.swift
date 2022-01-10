//
//  LoadingScreenWithSpinner.swift
//  GBShop
//
//  Created by Владимир on 04.01.2022.
//

import UIKit

final class LoadingScreenWithSpinner {

    private weak var parent: UIView?
    private var center: CGPoint
    
    private var canvas: UIView = UIView()
    private var spinner: UIActivityIndicatorView = UIActivityIndicatorView()
    
    init(view: UIView, center: CGPoint? = nil) {
        parent = view
        if let point = center {
            self.center = point
        } else {
            self.center = view.center
        }
    }
    
    deinit {
        parent = nil
    }
    
    public func show() {
        if let view = parent {
            DispatchQueue.main.async {
                self.canvas.frame = view.frame
                self.canvas.center = view.center
                self.canvas.backgroundColor = .systemGray2.withAlphaComponent(0.7)
                        
                self.spinner.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
                self.spinner.center = self.center
                self.spinner.style = .large
                self.spinner.color = .systemRed

                self.canvas.addSubview(self.spinner)
                view.addSubview(self.canvas)
                
                self.spinner.startAnimating()
            }
        }
    }
    
    public func hide() {
        if parent != nil {
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.canvas.removeFromSuperview()
            }
        }
    }
}
