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
        dicTojson(dictionary: selectReporte())
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        webViewReporte.delegate = self
        webViewReporte.loadRequest(URLRequest(url: dir.appendingPathComponent("reporte.html")))
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
