//
//  CKDefaults.swift
//  Browser
//
//  Created by Blake Tsuzaki on 5/10/18.
//  Copyright © 2018 Modoki. All rights reserved.
//

import UIKit

class CKDefaults {
    static let bevelWidth: CGFloat = 1
    static let backgroundColor = UIColor(named: "magnesium")
    static let desktopColor = UIColor(named: "teal")
    static let highlightColor = UIColor(named: "midnight")
    static let textureLightColor = UIColor(named: "silver")
    static let fontName = "MS Sans Serif"
    
    class func drawInsetBevel(with bounds: CGRect) {
        let outerBottom = UIBezierPath()
        let innerBottom = UIBezierPath()
        let innerTop = UIBezierPath()
        let outerTop = UIBezierPath()
        let lineWidth: CGFloat = CKDefaults.bevelWidth
        
        innerBottom.lineWidth = lineWidth
        innerBottom.move(to: CGPoint(x: 0, y: bounds.height - lineWidth/2))
        innerBottom.addLine(to: CGPoint(x: bounds.width - lineWidth/2, y: bounds.height - lineWidth/2))
        innerBottom.addLine(to: CGPoint(x: bounds.width - lineWidth/2, y: 0))
        UIColor.white.set()
        innerBottom.stroke()
        
        outerBottom.lineWidth = lineWidth
        outerBottom.move(to: CGPoint(x: lineWidth, y: bounds.height - lineWidth * 1.5))
        outerBottom.addLine(to: CGPoint(x: bounds.width - lineWidth * 1.5, y: bounds.height - lineWidth * 1.5))
        outerBottom.addLine(to: CGPoint(x: bounds.width - lineWidth * 1.5, y: lineWidth))
        UIColor(white: 1, alpha: 0.5).set()
        outerBottom.stroke()
        
        outerTop.lineWidth = lineWidth
        outerTop.move(to: CGPoint(x: lineWidth/2, y: bounds.height - lineWidth))
        outerTop.addLine(to: CGPoint(x: lineWidth/2, y: lineWidth/2))
        outerTop.addLine(to: CGPoint(x: bounds.width - lineWidth, y: lineWidth/2))
        UIColor(white: 0, alpha: 0.3).set()
        outerTop.stroke()
        
        innerTop.lineWidth = lineWidth
        innerTop.move(to: CGPoint(x: lineWidth * 1.5, y: bounds.height - lineWidth * 2))
        innerTop.addLine(to: CGPoint(x: lineWidth * 1.5, y: lineWidth * 1.5))
        innerTop.addLine(to: CGPoint(x: bounds.width - lineWidth * 2, y: lineWidth * 1.5))
        UIColor.black.set()
        innerTop.stroke()
    }
}

extension UIColor {
    func lighter(by percentage: CGFloat = 30) -> UIColor {
        return self.adjust(by: abs(percentage))
    }
    func darker(by percentage: CGFloat = 30) -> UIColor {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30) -> UIColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }else{
            return UIColor()
        }
    }
}
