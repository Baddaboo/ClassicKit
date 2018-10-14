//
//  CKTextField.swift
//  Browser
//
//  Created by Blake Tsuzaki on 5/11/18.
//  Copyright © 2018 Modoki. All rights reserved.
//

import UIKit

@IBDesignable class CKTextField: UIView {
    @IBInspectable var textSize: CGFloat = 30 {
        didSet { textfield.font = UIFont(name: CKDefaults.fontName, size: textSize) }
    }
    
    @IBInspectable var placeholderText: String = "" {
        didSet { textfield.placeholder = placeholderText }
    }
    
    @IBInspectable var text: String? {
        get { return textfield.text }
        set { textfield.text = newValue }
    }
    
    var returnKeyType: UIReturnKeyType {
        get { return textfield.returnKeyType }
        set { textfield.returnKeyType = newValue }
    }

    var keyboardType: UIKeyboardType {
        get { return textfield.keyboardType }
        set { textfield.keyboardType = newValue }
    }

    var delegate: UITextFieldDelegate? {
        didSet {
            textfield.delegate = delegate
        }
    }
    
    private class _TextField: UITextField {
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            var frame = bounds
            frame.origin.x = 5
            frame.size.width -= 5
            return frame
        }
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            var frame = bounds
            frame.origin.x = 5
            frame.size.width -= 5
            return frame
        }
    }
    
    private let textfield = _TextField()
    
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
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.font = UIFont(name: CKDefaults.fontName, size: 30)
        
        textfield.backgroundColor = .white
        addSubview(textfield)
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        textfield.addTarget(target, action: action, for: controlEvents)
    }
    
    func hideKeyboard() {
        textfield.resignFirstResponder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        CKDefaults.drawInsetBevel(with: rect)

        let lineWidth: CGFloat = CKDefaults.bevelWidth
        
        var contentFrame = CGRect()
        contentFrame.origin.x = lineWidth * 2
        contentFrame.origin.y = lineWidth * 2
        contentFrame.size.height = rect.size.height - lineWidth * 4
        contentFrame.size.width = rect.size.width - lineWidth * 4
        
        textfield.frame = contentFrame
    }
}
