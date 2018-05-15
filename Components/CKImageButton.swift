//
//  CKImageButton.swift
//  Browser
//
//  Created by Blake Tsuzaki on 5/11/18.
//  Copyright © 2018 Modoki. All rights reserved.
//

import UIKit

@IBDesignable
class CKImageButton: CKButton {

    @IBInspectable
    var image: UIImage? {
        didSet { imageView.image = image }
    }
    
    @IBInspectable
    var imageInset: CGFloat = 0
    
    let imageView = UIImageView()
    
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
        imageView.layer.magnificationFilter = kCAFilterNearest
        contentView.addSubview(imageView)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        imageView.frame = contentView.bounds.insetBy(dx: imageInset, dy: imageInset)
    }
}
