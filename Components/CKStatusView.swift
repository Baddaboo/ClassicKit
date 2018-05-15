//
//  CKStatusView.swift
//  Browser
//
//  Created by Blake Tsuzaki on 5/11/18.
//  Copyright © 2018 Modoki. All rights reserved.
//

import UIKit



class CKStatusView: CKContentWrapperView {

    @IBInspectable
    var message: String = "" {
        didSet {
            label.text = message
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
        label.font = UIFont(name: CKDefaults.fontName, size: 20)
        label.textColor = .black
        
        contentView = label
    }
}
