//
//  ReferidoViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 28/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class ReferidoViewController: UIViewController {

    var nuevo: Bool = true
    var referido: [String:String] = ["id":"", "nombre":"", "apaterno":"", "amaterno":"", "telefono":""]

    @IBOutlet weak var textNombre: UITextField!
    @IBOutlet weak var textApaterno: UITextField!
    @IBOutlet weak var textAmaterno: UITextField!
    @IBOutlet weak var textTelefono: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textNombre.text = referido["nombre"]
        textApaterno.text = referido["apaterno"]
        textAmaterno.text = referido["amaterno"]
        textTelefono.text = referido["telefono"]
    }
    
    @IBAction func guardarReferido(_ sender: UIButton) {
        referido["nombre"] = textNombre.text
        referido["apaterno"] = textApaterno.text
        referido["amaterno"] = textAmaterno.text
        referido["telefono"] = textTelefono.text
        if nuevo {
            ejecutarenReferidos(accion: "insert", persona: referido)
        }
        else {
            ejecutarenReferidos(accion: "update", persona: referido)
        }
    }
    
    @IBAction func eliminarReferido(_ sender: UIButton) {
        if !nuevo {
            ejecutarenReferidos(accion: "delete", persona: referido)
        }
    }
    
    @IBAction func cancelar(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindReferido", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
