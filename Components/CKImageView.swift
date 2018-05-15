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
class CKImageView: CKContentWrapperView {
    
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
        
        contentView.removeFromSuperview()
        contentView = imageView
        addSubview(contentView)
    }
}
