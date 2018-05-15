//
//  CKTextButton.swift
//  Browser
//
//  Created by Blake Tsuzaki on 5/11/18.
//  Copyright © 2018 Modoki. All rights reserved.
//

import UIKit

@IBDesignable
class CKTextButton: CKButton {
    @IBInspectable
    var textColor: UIColor = .black {
        didSet { label.textColor = textColor }
    }
    @IBInspectable
    var text: String = "" {
        didSet { label.text = text }
    }
    @IBInspectable
    var textSize: CGFloat = 30 {
        didSet { label.font = UIFont(name: CKDefaults.fontName, size: textSize) }
    }
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    private func configure() {
        isOpaque = false
        
        label.font = UIFont(name: CKDefaults.fontName, size: 30)
        label.textColor = textColor
        label.textAlignment = .center
        
        contentView = label
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
}
