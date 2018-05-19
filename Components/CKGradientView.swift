//
//  CKGradientView.swift
//  Spotify
//
//  Created by Blake Tsuzaki on 5/17/18.
//  Copyright © 2018 Modoki. All rights reserved.
//

import UIKit

@IBDesignable
class CKGradientView: UIView {
    
    @IBInspectable
    var firstColor: UIColor = .white
    
    @IBInspectable
    var secondColor: UIColor = .black
    
    var additionalColors = [UIColor]()
    
    @IBInspectable
    var verticalGradient: Bool = false
    
    private var gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        var additionalColors = [CGColor]()
        for color in self.additionalColors { additionalColors.append(color.cgColor) }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor] + additionalColors
        gradientLayer.startPoint = CGPoint()
        
        if verticalGradient {
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        } else {
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        }
        
        layer.replaceSublayer(self.gradientLayer, with: gradientLayer)
        
        self.gradientLayer = gradientLayer
    }
}
