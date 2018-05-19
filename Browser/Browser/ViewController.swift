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
    @IBOutlet weak var statusBar: CKStatusView!
    @IBOutlet weak var progressView: CKProgressView!
    @IBOutlet weak var imageView: CKImageView!
    @IBOutlet weak var wrapperView: CKContentWrapperView!
    
    var webView: WKWebView = WKWebView()
    var player: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        wrapperView.contentView = webView
        
        statusBar.message = "Ready"
        
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
        
        addressBar.returnKeyType = .go
        addressBar.addTarget(self, action: #selector(ViewController.goButtonTapped), for: .primaryActionTriggered)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageView.shouldAnimate = false
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
        addressBar.text = "https://google.com/"
        goButtonTapped()
    }
    
    @objc func stopButtonTapped() {
        webView.stopLoading()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.value = CGFloat(webView.estimatedProgress)
        }
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        
        if motion == .motionShake {
            let viewController = CKBlueScreenViewController()
            viewController.errorReason = "TOO_MUCH_SHAKING"
            present(viewController, animated: false, completion: nil)
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
