//
//  WebViewController.swift
//  JikanDemo
//
//  Created by ice on 2022/4/11.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    var webView: WKWebView!
    
    var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUI()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.load(URLRequest(url: url))
    }

    func makeUI() {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.allowsPictureInPictureMediaPlayback = true
        webView = WKWebView(frame: CGRect.zero, configuration: config)
        webView.allowsBackForwardNavigationGestures = true
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func bindViewModel() {
        
    }
}
