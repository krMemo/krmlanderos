//
//  ReportesViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 12/11/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class ReportesViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webViewReporte: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        webViewReporte.delegate = self
        webViewReporte.loadRequest(URLRequest(url: URL(fileURLWithPath: Bundle.main.path(forResource: "Web/reporte", ofType: "html")!)))
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        print("Started to load")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("Finished loading")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
