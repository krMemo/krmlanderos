//
//  ClienteViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 28/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class ClienteViewController: UIViewController {

    var nuevo: Bool = true
    var cliente: [String:String] = ["id":"", "nombre":"", "apaterno":"", "amaterno":"", "telefono":""]
    
    @IBOutlet weak var textNombre: UITextField!
    @IBOutlet weak var textApaterno: UITextField!
    @IBOutlet weak var textAmaterno: UITextField!
    @IBOutlet weak var textTelefono: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !nuevo {
            textNombre.text = cliente["nombre"]
            textApaterno.text = cliente["apaterno"]
            textAmaterno.text = cliente["amaterno"]
            textTelefono.text = cliente["telefono"]
        }
    }
    
    @IBAction func guardarCliente(_ sender: UIButton) {
        cliente["nombre"] = textNombre.text
        cliente["apaterno"] = textApaterno.text
        cliente["amaterno"] = textAmaterno.text
        cliente["telefono"] = textTelefono.text
        if nuevo {
            ejecutarenClientes(accion: "insert", persona: cliente)
        }
        else {
            ejecutarenClientes(accion: "update", persona: cliente)
        }
    }
    
    @IBAction func cancelar(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindCliente", sender: self)
    }
    
    @IBAction func eliminarCliente(_ sender: UIButton) {
        if !nuevo {
            ejecutarenClientes(accion: "delete", persona: cliente)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
