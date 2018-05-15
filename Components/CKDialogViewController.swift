//
//  CKDialogViewController.swift
//  Browser
//
//  Created by Blake Tsuzaki on 5/14/18.
//  Copyright © 2018 Modoki. All rights reserved.
//

import UIKit

class CKDialogViewController: UIViewController {
    var contentView: UIView = UIView() {
        didSet {
            oldValue.removeFromSuperview()
            dialogView.addSubview(contentView)
        }
    }
    
    private var dialogView = CKView()
    
    private let shadowView = UIView()
    private var tapGestureRecognizer: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dialogView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        dialogView.backgroundColor = CKDefaults.backgroundColor
        dialogView.addSubview(contentView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CKDialogViewController.shadowViewWasTapped))
        shadowView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        shadowView.addGestureRecognizer(tapGestureRecognizer)
        
        self.tapGestureRecognizer = tapGestureRecognizer
        
        view.addSubview(shadowView)
        view.addSubview(dialogView)
        view.backgroundColor = .clear
        view.isOpaque = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        shadowView.frame.origin = CGPoint()
        shadowView.frame.size = CGSize(width: view.frame.width, height: 0)
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
            self.shadowView.frame = self.view.bounds
        }, completion: nil)
    }
    
    @objc func shadowViewWasTapped() {
        dismiss(animated: false, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        dialogView.frame.size = CGSize(width: 250, height: 200)
        dialogView.center = view.center
        
        contentView.frame = dialogView.bounds
        shadowView.frame = view.bounds
    }
}
