//
//  CKView.swift
//  Browser
//
//  Created by Blake Tsuzaki on 5/10/18.
//  Copyright © 2018 Modoki. All rights reserved.
//

import UIKit

@IBDesignable class CKView: UIView {
    enum Style {
        case window, control
    }
    
    var style: Style = .window {
        didSet { setNeedsDisplay() }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let outerBottom = UIBezierPath()
        let innerBottom = UIBezierPath()
        let innerTop = UIBezierPath()
        let outerTop = UIBezierPath()
        let lineWidth: CGFloat = CKDefaults.bevelWidth
        
        switch style {
        case .control: fallthrough
        case .window:
            outerBottom.lineWidth = lineWidth
            outerBottom.move(to: CGPoint(x: 0, y: bounds.height - lineWidth/2))
            outerBottom.addLine(to: CGPoint(x: bounds.width - lineWidth/2, y: bounds.height - lineWidth/2))
            outerBottom.addLine(to: CGPoint(x: bounds.width - lineWidth/2, y: 0))
            UIColor.black.set()
            outerBottom.stroke()
            
            innerBottom.lineWidth = lineWidth
            innerBottom.move(to: CGPoint(x: lineWidth, y: bounds.height - lineWidth * 1.5))
            innerBottom.addLine(to: CGPoint(x: bounds.width - lineWidth * 1.5, y: bounds.height - lineWidth * 1.5))
            innerBottom.addLine(to: CGPoint(x: bounds.width - lineWidth * 1.5, y: lineWidth))
            UIColor(white: 0, alpha: 0.3).set()
            innerBottom.stroke()
            
            outerTop.lineWidth = lineWidth
            outerTop.move(to: CGPoint(x: lineWidth/2, y: bounds.height - lineWidth))
            outerTop.addLine(to: CGPoint(x: lineWidth/2, y: lineWidth/2))
            outerTop.addLine(to: CGPoint(x: bounds.width - lineWidth, y: lineWidth/2))
            style == .window ? UIColor(white: 1, alpha: 0.5).set() : UIColor.white.set()
            outerTop.stroke()
            
            innerTop.lineWidth = lineWidth
            innerTop.move(to: CGPoint(x: lineWidth * 1.5, y: bounds.height - lineWidth * 2))
            innerTop.addLine(to: CGPoint(x: lineWidth * 1.5, y: lineWidth * 1.5))
            innerTop.addLine(to: CGPoint(x: bounds.width - lineWidth * 2, y: lineWidth * 1.5))
            style == .window ? UIColor.white.set() : UIColor(white: 1, alpha: 0.5).set()
            innerTop.stroke()
        }
    }
}
