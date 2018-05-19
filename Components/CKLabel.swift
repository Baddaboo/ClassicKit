//
//  CKLabel.swift
//  Browser
//
//  Created by Blake Tsuzaki on 5/11/18.
//  Copyright © 2018 Modoki. All rights reserved.
//

import UIKit

@IBDesignable class CKLabel: UILabel {
    @IBInspectable var textSize: CGFloat = 30 {
        didSet {
            font = UIFont(name: CKDefaults.fontName, size: textSize)
        }
    }
    
    @IBInspectable var leftInset: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    private func configure() {
        font = UIFont(name: CKDefaults.fontName, size: 30)
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: 0)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}
