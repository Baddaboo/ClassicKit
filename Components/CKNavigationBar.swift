//
//  CKNavigationBar.swift
//  Browser
//
//  Created by Blake Tsuzaki on 5/11/18.
//  Copyright © 2018 Modoki. All rights reserved.
//

import UIKit

@IBDesignable class CKNavigationBar: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let outerBottom = UIBezierPath()
        let innerBottom = UIBezierPath()
        let lineWidth: CGFloat = CKDefaults.bevelWidth
        
        outerBottom.lineWidth = lineWidth
        outerBottom.move(to: CGPoint(x: 0, y: bounds.height - lineWidth/2))
        outerBottom.addLine(to: CGPoint(x: bounds.width, y: bounds.height - lineWidth/2))
        UIColor.black.set()
        outerBottom.stroke()
        
        innerBottom.lineWidth = lineWidth
        innerBottom.move(to: CGPoint(x: 0, y: bounds.height - lineWidth * 1.5))
        innerBottom.addLine(to: CGPoint(x: bounds.width, y: bounds.height - lineWidth * 1.5))
        UIColor(white: 0, alpha: 0.3).set()
        innerBottom.stroke()
    }
}
