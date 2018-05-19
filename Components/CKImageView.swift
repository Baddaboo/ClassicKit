//
//  CKImageView.swift
//  Browser
//
//  Created by Blake Tsuzaki on 5/14/18.
//  Copyright © 2018 Modoki. All rights reserved.
//

import UIKit
import YYImage

@IBDesignable
class CKImageView: UIView {
    
    var image: UIImage? {
        get { return imageView.image }
        set { imageView.image = newValue }
    }
    
    @IBInspectable
    var shouldAnimate: Bool {
        get { return imageView.isAnimating }
        set {
            if newValue { imageView.startAnimating() }
            else {
                imageView.stopAnimating()
                imageView.currentAnimatedImageIndex = 0
            }
        }
    }
    
    private let imageView = YYAnimatedImageView()
    
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
        
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        CKDefaults.drawInsetBevel(with: rect)
        
        let lineWidth: CGFloat = CKDefaults.bevelWidth
        
        var contentFrame = CGRect()
        contentFrame.origin.x = lineWidth * 2
        contentFrame.origin.y = lineWidth * 2
        contentFrame.size.height = rect.size.height - lineWidth * 4
        contentFrame.size.width = rect.size.width - lineWidth * 4
        
        imageView.frame = contentFrame
    }
}
