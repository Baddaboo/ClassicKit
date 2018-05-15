//
//  CKHorizontalScrollBar.swift
//  Browser
//
//  Created by Blake Tsuzaki on 5/11/18.
//  Copyright © 2018 Modoki. All rights reserved.
//

import UIKit

@IBDesignable
class CKHorizontalScrollBar: UIControl {
    @IBInspectable
    var buttonColor: UIColor? {
        didSet {
            leftButton.buttonColor = buttonColor
            rightButton.buttonColor = buttonColor
            slider.backgroundColor = buttonColor
        }
    }
    
    @IBInspectable
    var value: CGFloat = 0 {
        didSet {
            if value > range { value = range }
            else if value < 0 { value = 0 }
            if value != oldValue {
                setNeedsLayout()
                if isScrolling {
                    sendActions(for: .valueChanged)
                }
            }
        }
    }
    
    @IBInspectable
    var range: CGFloat = 100 {
        didSet {
            if range <= 0 { range = 1 }
            else if range != oldValue { setNeedsLayout() }
        }
    }
    
    @IBInspectable
    var thumbSize: CGFloat = 100 {
        didSet {
            if thumbSize < frame.size.width { thumbSize = frame.size.width }
            else if thumbSize != oldValue { setNeedsLayout() }
        }
    }
    
    var isScrolling = false
    var scrollSize: CGFloat { return frame.size.width - 2 * frame.size.height }
    
    let leftButton = CKImageButton()
    let rightButton = CKImageButton()
    let slider = CKView()
    
    private var basePoint = CGPoint()
    private var baseValue: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    private func configure() {
        leftButton.image = UIImage(named: "scrollbar-left")
        leftButton.addTarget(self, action: #selector(CKHorizontalScrollBar.leftButtonPressed), for: .touchUpInside)
        rightButton.image = UIImage(named: "scrollbar-right")
        rightButton.addTarget(self, action: #selector(CKHorizontalScrollBar.rightButtonPressed), for: .touchUpInside)
        slider.isUserInteractionEnabled = false
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(slider)
    }
    
    @objc func leftButtonPressed() {
        isScrolling = true
        value -= range/10
        isScrolling = false
    }
    
    @objc func rightButtonPressed() {
        isScrolling = true
        value += range/10
        isScrolling = false
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)
        
        isScrolling = true
        
        if slider.frame.contains(touchPoint) {
            basePoint = touchPoint
            baseValue = value
            return true
        }
        return false
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)
        value = baseValue + range * (touchPoint.x - basePoint.x)/(frame.size.width - 2 * frame.size.height - slider.frame.size.width)
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        isScrolling = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var leftFrame = CGRect()
        leftFrame.size.height = frame.size.height
        leftFrame.size.width = frame.size.height
        leftFrame.origin = CGPoint()
        leftButton.frame = leftFrame
        
        var rightFrame = CGRect()
        rightFrame.size.height = frame.size.height
        rightFrame.size.width = frame.size.height
        rightFrame.origin.y = 0
        rightFrame.origin.x = frame.size.width - frame.size.height
        rightButton.frame = rightFrame
        
        var thumbFrame = CGRect()
        thumbFrame.size.height = frame.size.height
        thumbFrame.size.width = min(thumbSize, frame.size.width - 2 * frame.size.height)
        thumbFrame.origin.y = 0
        thumbFrame.origin.x = (value / range) * (frame.size.width - 2 * frame.size.height - thumbFrame.size.width) + frame.size.height
        slider.frame = thumbFrame
        
        if state == .disabled || thumbSize >= scrollSize {
            isUserInteractionEnabled = false
            slider.isHidden = true
            leftButton.isEnabled = false
            rightButton.isEnabled = false
        } else {
            isUserInteractionEnabled = true
            slider.isHidden = false
            leftButton.isEnabled = true
            rightButton.isEnabled = true
        }
    }
}
