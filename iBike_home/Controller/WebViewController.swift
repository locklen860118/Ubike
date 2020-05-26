//
//  WebViewController.swift
//  iBike_home
//
//  Created by CY0290 on 2020/5/19.
//  Copyright © 2020 Chris. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {

   var webView: WKWebView!
    override func viewDidLoad() {
       super.viewDidLoad()
       let myURL = URL(string:"https://i.youbike.com.tw/home")
       let myRequest = URLRequest(url: myURL!)
       webView.load(myRequest)
    }
    override func loadView() {
       let webConfiguration = WKWebViewConfiguration()
       webView = WKWebView(frame: .zero, configuration: webConfiguration)
       webView.uiDelegate = self
       view = webView
    }

}
