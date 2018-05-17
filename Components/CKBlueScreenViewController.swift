//
//  CKBlueScreenViewController.swift
//  Browser
//
//  Created by Blake Tsuzaki on 5/17/18.
//  Copyright © 2018 Modoki. All rights reserved.
//

import UIKit

class CKBlueScreenViewController: UIViewController {
    let productLabelHorizontalMargin: CGFloat = 10
    let textDelay: TimeInterval = 0.5
    let textIncrement: TimeInterval = 0.05
    
    var textSize: CGFloat = 11
    var errorReason: String = ""
    
    override var prefersStatusBarHidden: Bool { return true }
    
    private var gestureRecognizer: UITapGestureRecognizer?
    private var productLabel = CKLabel()
    private var endLabel = CKLabel()
    private var textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognzier = UITapGestureRecognizer(target: self, action: #selector(CKBlueScreenViewController.viewWasTapped))
        
        productLabel.text = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "iOS"
        productLabel.textSize = textSize
        productLabel.textColor = .blue
        productLabel.backgroundColor = CKDefaults.textureLightColor
        productLabel.textAlignment = .center
        
        endLabel.text = "Tap anywhere to continue _"
        endLabel.textSize = textSize
        endLabel.textColor = .white
        endLabel.textAlignment = .center
        
        textView.font = UIFont(name: CKDefaults.fontName, size: textSize)
        textView.textColor = .white
        textView.backgroundColor = .clear
        
        view.addGestureRecognizer(gestureRecognzier)
        view.backgroundColor = .blue
        view.addSubview(productLabel)
        view.addSubview(textView)
        view.addSubview(endLabel)
        
        self.gestureRecognizer = gestureRecognzier
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.text = "A fatal exception has occured: \(errorReason).  The current application will be terminated.\n\n*    Tap anywhere to terminate the current application.\n*    You will lose any unsaved information in this application."
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        productLabel.isHidden = true
        textView.isHidden = true
        endLabel.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + textDelay) {
            self.productLabel.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + textDelay + textIncrement) {
            self.textView.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + textDelay + 2 * textIncrement) {
            self.endLabel.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        textView.frame.size = CGSize(width: 280, height: 100)
        textView.center = view.center
        
        if let productText = productLabel.text {
            productLabel.frame.size = productText.size(withAttributes: [NSAttributedStringKey.font: UIFont(name: CKDefaults.fontName, size: textSize) as Any])
            productLabel.frame.size.width += productLabelHorizontalMargin
            productLabel.center = CGPoint(x: view.center.x, y: textView.frame.origin.y - productLabel.frame.size.height)
        }
        
        endLabel.frame.size = CGSize(width: textView.frame.size.width, height: 20)
        endLabel.center = CGPoint(x: view.center.x, y: textView.frame.origin.y + textView.frame.size.height + endLabel.frame.size.height)
    }
    
    @objc func viewWasTapped() {
        fatalError()
    }
}
