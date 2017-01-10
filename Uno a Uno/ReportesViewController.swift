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
    @IBOutlet weak var segReportes: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        dicTojson(archivo: "LlamadasCitas.json", reporteLlamadasCitas())
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        webViewReporte.delegate = self
        webViewReporte.loadRequest(URLRequest(url: dir.appendingPathComponent("repLlamadasCitas.html")))
    }
    
    @IBAction func selectReporte(_ sender: UISegmentedControl) {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        if segReportes.selectedSegmentIndex == 0 {
            dicTojson(archivo: "LlamadasCitas.json", reporteLlamadasCitas())
            webViewReporte.loadRequest(URLRequest(url: dir.appendingPathComponent("repLlamadasCitas.html")))
        }
        else if segReportes.selectedSegmentIndex == 1 {
            dicTojson(archivo: "ClientesReferidos.json", reporteClientesReferidos())
            webViewReporte.loadRequest(URLRequest(url: dir.appendingPathComponent("repClientesReferidos.html")))
        }
    }

    @IBAction func recargar(_ sender: UIButton) {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        if segReportes.selectedSegmentIndex == 0 {
            dicTojson(archivo: "LlamadasCitas.json", reporteLlamadasCitas())
            webViewReporte.loadRequest(URLRequest(url: dir.appendingPathComponent("repLlamadasCitas.html")))
        }
        else if segReportes.selectedSegmentIndex == 1 {
            dicTojson(archivo: "ClientesReferidos.json", reporteClientesReferidos())
            webViewReporte.loadRequest(URLRequest(url: dir.appendingPathComponent("repClientesReferidos.html")))
        }
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
