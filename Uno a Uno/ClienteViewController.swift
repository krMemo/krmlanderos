//
//  ClienteViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 28/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class ClienteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelar(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindCliente", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
