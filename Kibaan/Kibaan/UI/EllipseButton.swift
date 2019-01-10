//
//  EllipseButton.swift
//  Kibaan
//
//  Created by altonotes on 2019/01/10.
//  Copyright © 2019 altonotes Inc. All rights reserved.
//

import Foundation

class EllipseButton: SmartButton {
    
    // MARK: - Variables
    
    private var borderLayer = CAShapeLayer()
    
    public override var cornerRadius: CGFloat {
        get { return layer.mask?.cornerRadius ?? 0 }
        set(value) {
            updateOutlineLayer(radius: value)
        }
    }
    
    public override var borderWidth: CGFloat {
        get { return borderLayer.lineWidth }
        set(value) {
            updateOutlineLayer(width: value)
        }
    }
    
    public override var borderColor: UIColor? {
        get {
            if let cgColor = borderLayer.strokeColor {
                return UIColor(cgColor: cgColor)
            }
            return nil
        }
        set(value) {
            updateOutlineLayer(color: value)
        }
    }
    
    // MARK: - Life cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateOutlineLayer()
    }
    
    // MARK: - Functions
    
    private func updateOutlineLayer(color: UIColor? = nil, width: CGFloat? = nil, radius: CGFloat? = nil) {
        let color = color ?? borderColor
        let width = width ?? borderWidth
        let radius = radius ?? cornerRadius
        let path = CGPath(ellipseIn: bounds, transform: nil)
        
        let clippingLayer = CAShapeLayer()
        clippingLayer.path = path
        clippingLayer.cornerRadius = radius
        layer.mask = clippingLayer
        
        borderLayer.removeFromSuperlayer()
        borderLayer.path = path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color?.cgColor
        borderLayer.lineWidth = width
        layer.addSublayer(borderLayer)
    }
}
