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
    static let fontName = "fs Tahoma 8px"
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
