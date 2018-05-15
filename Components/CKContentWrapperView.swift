//
//  CKContentWrapperView.swift
//  Browser
//
//  Created by Blake Tsuzaki on 5/11/18.
//  Copyright © 2018 Modoki. All rights reserved.
//

import UIKit

@IBDesignable
class CKContentWrapperView: UIControl {
    var contentView: UIView = UIScrollView() {
        didSet {
            oldValue.removeFromSuperview()
            addSubview(contentView)
            setNeedsDisplay()
        }
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
        backgroundColor = .clear
        
        if let contentView = contentView as? UIScrollView {
            contentView.alwaysBounceVertical = true
            contentView.clipsToBounds = true
        }
        addSubview(contentView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
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
        
        var contentFrame = CGRect()
        contentFrame.origin.x = lineWidth * 2
        contentFrame.origin.y = lineWidth * 2
        contentFrame.size.height = rect.size.height - lineWidth * 4
        contentFrame.size.width = rect.size.width - lineWidth * 4
        
        contentView.frame = contentFrame
    }
}
