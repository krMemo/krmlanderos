//
//  ConfiguracionViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 14/12/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class ConfiguracionViewController: UIViewController {

    @IBOutlet weak var buttonImportar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func importarContactos(_ sender: UIButton) {
        if permisoContactos {
            self.performSegue(withIdentifier: "segueImportar", sender: self)
        }
        else {
            mostrarAviso(titulo: "Importante", mensaje: "Debe autorizar el acceso a sus contactos", viewController: self)
        }
    }

    @IBAction func cerrarSesion(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindConfiguracion", sender: self)
    }
    
    @IBAction func unwindImportar(sender: UIStoryboardSegue) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
