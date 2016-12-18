//
//  ConfiguracionViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 14/12/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class ConfiguracionViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func importarContactos(_ sender: UIButton) {
        
    }

    @IBAction func cerrarSesion(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindConfiguracion", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
