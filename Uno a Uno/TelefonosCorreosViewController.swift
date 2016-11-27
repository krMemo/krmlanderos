//
//  TelefonosCorreosViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 27/11/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class TelefonosCorreosViewController: UIViewController {
    
    var id: String = ""
    var telefonos: [[String:String]] = []
    var telefono: [String:String] = ["id":"", "idx":"", "principal":"", "telefono":"", "tipo":""]
    var correos: [[String:String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*telefono["id"] = id
        telefono["idx"] = "0"
        telefono["principal"] = "1"
        telefono["telefono"] = "534534"
        telefono["tipo"] = "iPhone"
        telefonos.append(telefono)*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let clienteVC = segue.destination as! ClienteViewController
        clienteVC.telefonos = telefonos
    }
    
    @IBAction func cancelar(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindTelCor", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
