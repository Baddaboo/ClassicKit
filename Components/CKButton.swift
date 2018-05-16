//
//  CKButton.swift
//  Browser
//
//  Created by Blake Tsuzaki on 5/11/18.
//  Copyright © 2018 Modoki. All rights reserved.
//

import UIKit

@IBDesignable
class CKButton: UIControl {
    @IBInspectable
    var buttonColor: UIColor? {
        didSet { contentView.backgroundColor = buttonColor }
    }
    
    var contentView: UIView = UIView() {
        didSet {
            oldValue.removeFromSuperview()
            contentView.isUserInteractionEnabled = false
            insertSubview(contentView, belowSubview: shadeView)
            setNeedsDisplay()
        }
    }
    
    private var shadeView = UIView()
    
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
        
        contentView.isUserInteractionEnabled = false
        
        addSubview(contentView)
        
        shadeView.backgroundColor = UIColor(white: 0, alpha: 0.1)
        shadeView.isHidden = true
        
        addSubview(shadeView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        setNeedsDisplay()
        shadeView.isHidden = false
        sendActions(for: .touchDown)
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        setNeedsDisplay()
        if frame.contains(touch.location(in: self)) {
            sendActions(for: .touchDragInside)
        } else {
            sendActions(for: .touchDragOutside)
        }
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        setNeedsDisplay()
        shadeView.isHidden = true
        if let touch = touch, frame.contains(touch.location(in: self)) {
            sendActions(for: .touchUpInside)
        } else {
            sendActions(for: .touchUpOutside)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let outerBottom = UIBezierPath()
        let innerBottom = UIBezierPath()
        let innerTop = UIBezierPath()
        let outerTop = UIBezierPath()
        let lineWidth: CGFloat = CKDefaults.bevelWidth
        
        contentView.alpha = 1
        
        switch state {
        case .disabled:
            contentView.alpha = 0.5
            fallthrough
        case .normal:
            outerBottom.lineWidth = lineWidth
            outerBottom.move(to: CGPoint(x: 0, y: bounds.height - lineWidth/2))
            outerBottom.addLine(to: CGPoint(x: bounds.width - lineWidth/2, y: bounds.height - lineWidth/2))
            outerBottom.addLine(to: CGPoint(x: bounds.width - lineWidth/2, y: 0))
            UIColor.black.set()
            outerBottom.stroke()

            innerBottom.lineWidth = lineWidth
            innerBottom.move(to: CGPoint(x: lineWidth, y: bounds.height - lineWidth * 1.5))
            innerBottom.addLine(to: CGPoint(x: bounds.width - lineWidth * 1.5, y: bounds.height - lineWidth * 1.5))
            innerBottom.addLine(to: CGPoint(x: bounds.width - lineWidth * 1.5, y: lineWidth))
            buttonColor?.darker(by: 30).set()
            innerBottom.stroke()

            outerTop.lineWidth = lineWidth
            outerTop.move(to: CGPoint(x: lineWidth/2, y: bounds.height - lineWidth))
            outerTop.addLine(to: CGPoint(x: lineWidth/2, y: lineWidth/2))
            outerTop.addLine(to: CGPoint(x: bounds.width - lineWidth, y: lineWidth/2))
            UIColor.white.set()
            outerTop.stroke()

            innerTop.lineWidth = lineWidth
            innerTop.move(to: CGPoint(x: lineWidth * 1.5, y: bounds.height - lineWidth * 2))
            innerTop.addLine(to: CGPoint(x: lineWidth * 1.5, y: lineWidth * 1.5))
            innerTop.addLine(to: CGPoint(x: bounds.width - lineWidth * 2, y: lineWidth * 1.5))
            UIColor.white.set()
            innerTop.stroke()
            
            var contentFrame = CGRect()
            contentFrame.origin.x = lineWidth * 2
            contentFrame.origin.y = lineWidth * 2
            contentFrame.size.height = rect.size.height - lineWidth * 4
            contentFrame.size.width = rect.size.width - lineWidth * 4
            
            contentView.frame = contentFrame
            shadeView.frame = contentFrame
        case .highlighted:
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
            
            let innerInnerTop = UIBezierPath()
            innerInnerTop.lineWidth = lineWidth * 2
            innerInnerTop.move(to: CGPoint(x: lineWidth * 3, y: bounds.height - lineWidth * 2))
            innerInnerTop.addLine(to: CGPoint(x: lineWidth * 3, y: lineWidth * 3))
            innerInnerTop.addLine(to: CGPoint(x: bounds.width - lineWidth * 2, y: lineWidth * 3))
            contentView.backgroundColor?.set()
            innerInnerTop.stroke()
            
            var contentFrame = CGRect()
            contentFrame.origin.x = lineWidth * 4
            contentFrame.origin.y = lineWidth * 4
            contentFrame.size.height = rect.size.height - lineWidth * 6
            contentFrame.size.width = rect.size.width - lineWidth * 6
            
            contentView.frame = contentFrame
            
            contentFrame.origin.x = lineWidth * 2
            contentFrame.origin.y = lineWidth * 2
            contentFrame.size.height = rect.size.height - lineWidth * 4
            contentFrame.size.width = rect.size.width - lineWidth * 4
            
            shadeView.frame = contentFrame
        default: break
        }
    }
}
