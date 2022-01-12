//
//  ButtonWithBadge.swift
//  GBShop
//
//  Created by Владимир on 10.01.2022.
//

import UIKit

final class ButtonWithBadge: UIButton {
    
    private var canvas: CAShapeLayer = {
        let canvas = CAShapeLayer()
        canvas.opacity = 0.95
        canvas.fillColor = UIColor.systemRed.cgColor
        canvas.strokeColor = UIColor.systemRed.cgColor
        return canvas
    }()
    
    private(set) var badgeLayer: CATextLayer = {
        let label = CATextLayer()
        label.truncationMode = .end
        label.contentsGravity = .center
        label.alignmentMode = .center
        label.isWrapped = false
        label.fontSize = 12
        label.foregroundColor = UIColor.white.cgColor
        label.contentsScale = UIScreen.main.scale
        label.masksToBounds = true
        return label
    }()
    
    public func update(badgeCount: Int) {
        (badgeCount < 1) ? removeBadge() : setBadge(count: badgeCount)
    }
    
    public func setBadgeWithoutAnimation(count: Int) {
        addBadge()
        badgeLayer.string = String(count)
    }
    
    public func setBadge(count: Int) {
        addBadge()
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.fromValue = 0
        springAnimation.toValue = 1
        springAnimation.stiffness = 150
        springAnimation.mass = 1
        springAnimation.duration = 2
        canvas.add(springAnimation, forKey: nil)
        badgeLayer.string = String(count)
    }
 
    private func removeBadge() {
        badgeLayer.removeFromSuperlayer()
        canvas.removeFromSuperlayer()
    }
    
    private func addBadge() {
        if let shapeLayer = self.layer.sublayers?.filter({ $0 is CAShapeLayer }),
           let textLayer = self.layer.sublayers?.filter({ $0 is CATextLayer }),
           (shapeLayer.isEmpty && textLayer.isEmpty) {
            
            self.layer.addSublayer(canvas)
            canvas.addSublayer(badgeLayer)
            
            let size: CGSize = CGSize(width: 18, height: 18)
            let origin: CGPoint = CGPoint(x: frame.maxX - size.width/2, y: frame.minY - size.height/3)
            let offsetOrigin = CGPoint(x: 0, y: 1)
            
            canvas.frame = CGRect(origin: origin, size: size)
            canvas.path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: size)).cgPath
            badgeLayer.frame = CGRect(origin: offsetOrigin, size: size)
        }
    }
}
