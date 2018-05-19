//
//  CKVerticalScrollBar.swift
//  Browser
//
//  Created by Blake Tsuzaki on 5/11/18.
//  Copyright © 2018 Modoki. All rights reserved.
//

import UIKit

@IBDesignable class CKVerticalScrollBar: UIControl {
    @IBInspectable var buttonColor: UIColor? {
        didSet {
            upButton.buttonColor = buttonColor
            downButton.buttonColor = buttonColor
            slider.backgroundColor = buttonColor
        }
    }
    
    @IBInspectable var value: CGFloat = 0 {
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
    
    @IBInspectable var range: CGFloat = 100 {
        didSet {
            if range <= 0 { range = 1 }
            else if range != oldValue { setNeedsLayout() }
        }
    }
    
    @IBInspectable var thumbSize: CGFloat = 100 {
        didSet {
            if thumbSize < frame.size.width { thumbSize = frame.size.width }
            else if thumbSize != oldValue { setNeedsLayout() }
        }
    }
    
    var isScrolling = false
    var scrollSize: CGFloat { return frame.size.height - 2 * frame.size.width }
    var isGrayedOut: Bool { return state == .disabled || thumbSize >= scrollSize }
    
    private let upButton = CKImageButton()
    private let downButton = CKImageButton()
    private let slider = CKView()
    
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
        upButton.image = UIImage(named: "scrollbar-up")
        upButton.addTarget(self, action: #selector(CKVerticalScrollBar.upButtonPressed), for: .touchUpInside)
        downButton.image = UIImage(named: "scrollbar-down")
        downButton.addTarget(self, action: #selector(CKVerticalScrollBar.downButtonPressed), for: .touchUpInside)
        slider.isUserInteractionEnabled = false
        addSubview(upButton)
        addSubview(downButton)
        addSubview(slider)
    }
    
    @objc func upButtonPressed() {
        isScrolling = true
        value -= range/10
        isScrolling = false
    }
    
    @objc func downButtonPressed() {
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
        value = baseValue + range * (touchPoint.y - basePoint.y)/(frame.size.height - 2 * frame.size.width - slider.frame.size.height)
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        isScrolling = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var upFrame = CGRect()
        upFrame.size.height = frame.size.width
        upFrame.size.width = frame.size.width
        upFrame.origin = CGPoint()
        upButton.frame = upFrame
        
        var downFrame = CGRect()
        downFrame.size.height = frame.size.width
        downFrame.size.width = frame.size.width
        downFrame.origin.y = frame.size.height - frame.size.width
        downFrame.origin.x = 0
        downButton.frame = downFrame
        
        var thumbFrame = CGRect()
        thumbFrame.size.height = min(thumbSize, frame.size.height - 2 * frame.size.width)
        thumbFrame.size.width = frame.size.width
        thumbFrame.origin.y = (value / range) * (frame.size.height - 2 * frame.size.width - thumbFrame.size.height) + frame.size.width
        thumbFrame.origin.x = 0
        slider.frame = thumbFrame
        
        if isGrayedOut {
            isUserInteractionEnabled = false
            slider.isHidden = true
            upButton.isEnabled = false
            downButton.isEnabled = false
        } else {
            isUserInteractionEnabled = true
            slider.isHidden = false
            upButton.isEnabled = true
            downButton.isEnabled = true
        }
    }
}
