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
    
    private var badgeLayer: CATextLayer = {
        let label = CATextLayer()
        label.alignmentMode = .center
        label.isWrapped = false
        label.truncationMode = .end
        label.contentsGravity = .center
        label.fontSize = 12
        label.foregroundColor = UIColor.white.cgColor
        label.contentsScale = UIScreen.main.scale
        label.masksToBounds = true
        return label
    }()
    
    private var size: CGSize = CGSize(width: 18, height: 18)
    private lazy var origin: CGPoint = CGPoint(x: frame.maxX - size.width/2, y: frame.minY - size.height/3)

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let offsetOrigin = CGPoint(x: origin.x, y: origin.y + 1)
        canvas.path = UIBezierPath(ovalIn: CGRect(origin: origin, size: size)).cgPath
        badgeLayer.frame = CGRect(origin: offsetOrigin, size: size)
    }
    
    public func update(badgeCount: Int) {
        if badgeCount < 1 {
            removeBadge()
        } else {
            addDadge(count: badgeCount)
        }
    }
    
    private func addDadge(count: Int) {
        if let shapeLayer = self.layer.sublayers?.filter({ $0 is CAShapeLayer }),
           let textLayer = self.layer.sublayers?.filter({ $0 is CATextLayer }),
           (shapeLayer.isEmpty && textLayer.isEmpty) {
            
            canvas.removeFromSuperlayer()
            badgeLayer.removeFromSuperlayer()
            self.layer.addSublayer(canvas)
            self.layer.addSublayer(badgeLayer)
        }
        
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.fromValue = 0
        springAnimation.toValue = 1
        springAnimation.stiffness = 150
        springAnimation.mass = 1
        springAnimation.duration = 2
        
        canvas.add(springAnimation, forKey: nil)
        badgeLayer.add(springAnimation, forKey: nil)
        
        badgeLayer.string = String(count)
    }
    
    private func removeBadge() {
        canvas.removeFromSuperlayer()
        badgeLayer.removeFromSuperlayer()
    }
}
