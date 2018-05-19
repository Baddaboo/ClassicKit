//
//  CKContentWrapperView.swift
//  Browser
//
//  Created by Blake Tsuzaki on 5/11/18.
//  Copyright © 2018 Modoki. All rights reserved.
//

import UIKit
import WebKit

@IBDesignable class CKContentWrapperView: UIView {
    @IBInspectable var scrollBarWidth: CGFloat = 20 {
        didSet { setNeedsLayout() }
    }
    
    @IBInspectable var barColor: UIColor? = CKDefaults.backgroundColor {
        didSet {
            verticalScrollBar.buttonColor = barColor
            horizontalScrollBar.buttonColor = barColor
        }
    }
    
    @IBOutlet weak var contentView: UIView? {
        didSet {
            if let oldValue = oldValue {
                oldValue.removeFromSuperview()
            }
            if let contentView = contentView {
                addSubview(contentView)
                
                contentView.clipsToBounds = true
                
                if let contentView = contentView as? UIScrollView { scrollView = contentView }
                else if let contentView = contentView as? WKWebView { scrollView = contentView.scrollView }
                else { scrollView = nil }
            }
            setNeedsDisplay()
        }
    }
    
    private var verticalScrollBar = CKVerticalScrollBar()
    private var horizontalScrollBar = CKHorizontalScrollBar()
    private var scrollView: UIScrollView? {
        didSet {
            if let scrollView = scrollView {
                scrollView.showsVerticalScrollIndicator = false
                scrollView.showsHorizontalScrollIndicator = false
                scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: .new, context: nil)
                scrollView.delegate = self
            } else {
                verticalScrollBar.range = 1
                verticalScrollBar.value = 1
                horizontalScrollBar.range = 1
                horizontalScrollBar.value = 1
            }
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
        
        verticalScrollBar.range = 1
        verticalScrollBar.value = 1
        horizontalScrollBar.range = 1
        horizontalScrollBar.value = 1
        
        verticalScrollBar.buttonColor = barColor
        horizontalScrollBar.buttonColor = barColor
        
        if let contentView = contentView {
            addSubview(contentView)
        }
        addSubview(verticalScrollBar)
        addSubview(horizontalScrollBar)
        
        verticalScrollBar.addTarget(self, action: #selector(CKContentWrapperView.verticalSliderDidMove), for: .valueChanged)
        horizontalScrollBar.addTarget(self, action: #selector(CKContentWrapperView.horizontalSliderDidMove), for: .valueChanged)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let object = object as? UIScrollView, object == scrollView && keyPath == "contentSize" {
            let contentHeight = object.contentSize.height
            let frameHeight = object.frame.height
            verticalScrollBar.range = contentHeight - frameHeight
            verticalScrollBar.thumbSize = (frameHeight / contentHeight) * verticalScrollBar.scrollSize
            
            let contentWidth = object.contentSize.width
            let frameWidth = object.frame.width
            horizontalScrollBar.range = contentWidth - frameWidth
            horizontalScrollBar.thumbSize = (frameWidth / contentWidth) * horizontalScrollBar.scrollSize
        }
    }
    
    @objc func verticalSliderDidMove() {
        if verticalScrollBar.isScrolling {
            scrollView?.contentOffset.y = verticalScrollBar.value
        }
    }
    
    @objc func horizontalSliderDidMove() {
        if horizontalScrollBar.isScrolling {
            scrollView?.contentOffset.x = horizontalScrollBar.value
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let lineWidth = CKDefaults.bevelWidth
        
        if let contentView = contentView {
        var contentFrame = CGRect()
            contentFrame.origin.x = lineWidth * 2
            contentFrame.origin.y = lineWidth * 2
            contentFrame.size.height = frame.size.height - lineWidth * 4 - scrollBarWidth
            contentFrame.size.width = frame.size.width - lineWidth * 4 - scrollBarWidth
            
            contentView.frame = contentFrame
        }
        
        var verticalScrollFrame = CGRect()
        verticalScrollFrame.origin.x = frame.size.width - lineWidth * 2 - scrollBarWidth
        verticalScrollFrame.origin.y = lineWidth * 2
        verticalScrollFrame.size.height = frame.size.height - lineWidth * 4 - scrollBarWidth
        verticalScrollFrame.size.width = scrollBarWidth
        
        verticalScrollBar.frame = verticalScrollFrame
        
        var horizontalScrollFrame = CGRect()
        horizontalScrollFrame.origin.x = lineWidth * 2
        horizontalScrollFrame.origin.y = frame.size.height - lineWidth * 2 - scrollBarWidth
        horizontalScrollFrame.size.height = scrollBarWidth
        horizontalScrollFrame.size.width = frame.size.width - lineWidth * 4 - scrollBarWidth
        
        horizontalScrollBar.frame = horizontalScrollFrame
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        CKDefaults.drawInsetBevel(with: rect)
    }
}

extension CKContentWrapperView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !verticalScrollBar.isScrolling {
            verticalScrollBar.value = scrollView.contentOffset.y
        }
        if !horizontalScrollBar.isScrolling {
            horizontalScrollBar.value = scrollView.contentOffset.x
        }
        
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        verticalScrollBar.range = contentHeight - frameHeight
        verticalScrollBar.thumbSize = (frameHeight / contentHeight) * verticalScrollBar.scrollSize
        
        let contentWidth = scrollView.contentSize.width
        let frameWidth = scrollView.frame.width
        horizontalScrollBar.range = contentWidth - frameWidth
        horizontalScrollBar.thumbSize = (frameWidth / contentWidth) * horizontalScrollBar.scrollSize
    }
}
