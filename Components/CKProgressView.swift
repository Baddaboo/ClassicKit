//
//  CKProgressView.swift
//  Browser
//
//  Created by Blake Tsuzaki on 5/11/18.
//  Copyright © 2018 Modoki. All rights reserved.
//

import UIKit

@IBDesignable
class CKProgressView: CKContentWrapperView {
    @IBInspectable
    var value: CGFloat = 50 {
        didSet {
            if value != oldValue { setNeedsDisplay() }
        }
    }
    
    @IBInspectable
    var range: CGFloat = 100 {
        didSet {
            if range != oldValue { setNeedsDisplay() }
        }
    }
    
    @IBInspectable
    var spacing: CGFloat = 4 {
        didSet {
            if spacing != oldValue { setNeedsDisplay() }
        }
    }
    
    @IBInspectable
    var progressColor: UIColor = CKDefaults.highlightColor ?? UIColor.black {
        didSet {
            if progressColor != oldValue { setNeedsDisplay() }
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if state == .disabled { return }
        
        let totalBars = Double(floor(rect.width / (rect.height * 0.6)))
        let barWidth = (rect.width - CGFloat(totalBars + 1) * spacing)/CGFloat(totalBars)
        
        for idx in 0...Int(CGFloat(totalBars) * (value/range)) {
            let barPath = UIBezierPath()
            barPath.move(to: CGPoint(x: spacing * (CGFloat(idx) + 1) + CGFloat(idx) * barWidth, y: spacing))
            barPath.addLine(to: CGPoint(x: spacing * (CGFloat(idx) + 1) + CGFloat(idx) * barWidth, y: rect.height - spacing))
            barPath.addLine(to: CGPoint(x: spacing * (CGFloat(idx) + 1) + (CGFloat(idx) + 1) * barWidth, y: rect.height - spacing))
            barPath.addLine(to: CGPoint(x: spacing * (CGFloat(idx) + 1) + (CGFloat(idx) + 1) * barWidth, y: spacing))
            barPath.close()
            progressColor.set()
            barPath.fill()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
}
