//
//  CKFillableView.swift
//  Browser
//
//  Created by Blake Tsuzaki on 5/11/18.
//  Copyright © 2018 Modoki. All rights reserved.
//

import UIKit

@IBDesignable class CKFillableView: UIView {
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

        outerBottom.lineWidth = lineWidth
        outerBottom.move(to: CGPoint(x: 0, y: bounds.height - safeAreaInsets.bottom - lineWidth * 1.5))
        outerBottom.addLine(to: CGPoint(x: bounds.width, y: bounds.height - safeAreaInsets.bottom - lineWidth * 1.5))
        UIColor(white: 0, alpha: 0.3).set()
        outerBottom.stroke()

        innerBottom.lineWidth = lineWidth
        innerBottom.move(to: CGPoint(x: 0, y: bounds.height - safeAreaInsets.bottom - lineWidth * 0.5))
        innerBottom.addLine(to: CGPoint(x: bounds.width, y: bounds.height - safeAreaInsets.bottom - lineWidth * 0.5))
        UIColor(white: 1, alpha: 0.5).set()
        innerBottom.stroke()

        outerTop.lineWidth = lineWidth
        outerTop.move(to: CGPoint(x: 0, y: lineWidth * 0.5 + safeAreaInsets.top))
        outerTop.addLine(to: CGPoint(x: bounds.width, y: lineWidth * 0.5 + safeAreaInsets.top))
        UIColor(white: 0, alpha: 0.3).set()
        outerTop.stroke()

        innerTop.lineWidth = lineWidth
        innerTop.move(to: CGPoint(x: 0, y: lineWidth * 1.5 + safeAreaInsets.top))
        innerTop.addLine(to: CGPoint(x: bounds.width, y: lineWidth * 1.5 + safeAreaInsets.top))
        UIColor(white: 1, alpha: 0.5).set()
        innerTop.stroke()
    }
}
