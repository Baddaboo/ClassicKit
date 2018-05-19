//
//  CKStatusView.swift
//  Browser
//
//  Created by Blake Tsuzaki on 5/11/18.
//  Copyright © 2018 Modoki. All rights reserved.
//

import UIKit

@IBDesignable class CKStatusView: UIView {
    @IBInspectable var message: String = "" {
        didSet {
            label.text = message
        }
    }
    
    @IBInspectable var textSize: CGFloat = 16 {
        didSet {
            label.font = UIFont(name: CKDefaults.fontName, size: textSize)
        }
    }
    
    var label = CKLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    private func configure() {
        label.leftInset = 4
        label.font = UIFont(name: CKDefaults.fontName, size: textSize)
        label.textColor = .black
        
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        CKDefaults.drawInsetBevel(with: rect)
        
        let lineWidth = CKDefaults.bevelWidth
        
        var contentFrame = CGRect()
        contentFrame.origin.x = lineWidth * 2
        contentFrame.origin.y = lineWidth * 2
        contentFrame.size.height = rect.size.height - lineWidth * 4
        contentFrame.size.width = rect.size.width - lineWidth * 4
        
        label.frame = contentFrame
    }
}
