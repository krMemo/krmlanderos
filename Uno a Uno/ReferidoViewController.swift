//
//  ReferidoViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 28/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class ReferidoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelar(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindReferido", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
