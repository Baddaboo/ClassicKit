//
//  ViewController.swift
//  Browser
//
//  Created by Blake Tsuzaki on 5/10/18.
//  Copyright © 2018 Modoki. All rights reserved.
//

import AudioToolbox
import AVFoundation
import UIKit
import WebKit
import YYImage

class ViewController: UIViewController {

    @IBOutlet weak var backButton: CKImageButton!
    @IBOutlet weak var forwardButton: CKImageButton!
    @IBOutlet weak var homeButton: CKImageButton!
    @IBOutlet weak var stopButton: CKImageButton!
    @IBOutlet weak var refreshButton: CKImageButton!
    @IBOutlet weak var addressBar: CKTextField!
    @IBOutlet weak var goButton: CKTextButton!
    @IBOutlet weak var helpButton: CKImageButton!
    @IBOutlet weak var verticalScrollBar: CKVerticalScrollBar!
    @IBOutlet weak var horizontalScrollBar: CKHorizontalScrollBar!
    @IBOutlet weak var statusBar: CKStatusView!
    @IBOutlet weak var progressView: CKProgressView!
    @IBOutlet weak var imageView: CKImageView!
    @IBOutlet weak var webView: WKWebView!
    
    var player: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.delegate = self
        webView.scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        statusBar.message = "Ready"
        verticalScrollBar.range = 1
        verticalScrollBar.value = 1
        horizontalScrollBar.range = 1
        horizontalScrollBar.value = 1
        progressView.range = 1
        progressView.isEnabled = false
        backButton.isEnabled = false
        forwardButton.isEnabled = false
        stopButton.isEnabled = false
        
        if let url = Bundle.main.url(forResource: "Explorer", withExtension: "gif") {
            do {
                imageView.image = YYImage(data: try Data(contentsOf: url))
            } catch {}
            imageView.backgroundColor = .black
        }
        
        goButton.addTarget(self, action: #selector(ViewController.goButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(ViewController.backButtonTapped), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(ViewController.forwardButtonTapped), for: .touchUpInside)
        homeButton.addTarget(self, action: #selector(ViewController.homeButtonTapped), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(ViewController.stopButtonTapped), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(ViewController.refreshButtonTapped), for: .touchUpInside)
        helpButton.addTarget(self, action: #selector(ViewController.helpButtonTapped), for: .touchUpInside)
        verticalScrollBar.addTarget(self, action: #selector(ViewController.verticalSliderDidMove), for: .valueChanged)
        horizontalScrollBar.addTarget(self, action: #selector(ViewController.horizontalSliderDidMove), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageView.shouldAnimate = false
    }
    
    @objc func verticalSliderDidMove() {
        if verticalScrollBar.isScrolling {
            webView.scrollView.contentOffset.y = verticalScrollBar.value
        }
    }
    
    @objc func horizontalSliderDidMove() {
        if horizontalScrollBar.isScrolling {
            webView.scrollView.contentOffset.x = horizontalScrollBar.value
        }
    }
    
    @objc func refreshButtonTapped() {
        webView.reload()
    }
    
    @objc func helpButtonTapped() {
        let viewController = CKDialogViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.contentView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "aboutView").view
        present(viewController, animated: false, completion: nil)
    }
    
    @objc func goButtonTapped() {
        if let text = addressBar.text,
           let url = URL(string: text) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        addressBar.hideKeyboard()
    }
    
    @objc func backButtonTapped() {
        webView.goBack()
    }
    
    @objc func forwardButtonTapped() {
        webView.goForward()
    }
    
    @objc func homeButtonTapped() {
        addressBar.textfield.text = "https://google.com/"
        goButtonTapped()
    }
    
    @objc func stopButtonTapped() {
        webView.stopLoading()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let object = object as? UIScrollView, object == webView.scrollView && keyPath == "contentSize" {
            let contentHeight = webView.scrollView.contentSize.height
            let frameHeight = webView.frame.height
            verticalScrollBar.range = contentHeight - frameHeight
            verticalScrollBar.thumbSize = (frameHeight / contentHeight) * verticalScrollBar.scrollSize
            
            let contentWidth = webView.scrollView.contentSize.width
            let frameWidth = webView.frame.width
            horizontalScrollBar.range = contentWidth - frameWidth
            horizontalScrollBar.thumbSize = (frameWidth / contentWidth) * horizontalScrollBar.scrollSize
        }
        else if keyPath == "estimatedProgress" {
            progressView.value = CGFloat(webView.estimatedProgress)
        }
    }
    
    func playNavigationSound() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            if let url = Bundle.main.url(forResource: "Windows Navigation Start", withExtension: "wav") {
                player = AVPlayer(url: url)
                player.play()
            }
        } catch { print(error.localizedDescription) }
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !verticalScrollBar.isScrolling {
            verticalScrollBar.value = scrollView.contentOffset.y
        }
        if !horizontalScrollBar.isScrolling {
            horizontalScrollBar.value = scrollView.contentOffset.x
        }
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        statusBar.message = "Opening  page..."
        progressView.isEnabled = true
        stopButton.isEnabled = true
        
        playNavigationSound()
        addressBar.text = webView.url?.absoluteString
        imageView.shouldAnimate = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        statusBar.message = "Ready"
        progressView.isEnabled = false
        stopButton.isEnabled = false
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        
        addressBar.text = webView.url?.absoluteString
        imageView.shouldAnimate = false
    }
}
