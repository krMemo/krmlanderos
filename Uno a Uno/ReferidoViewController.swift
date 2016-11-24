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
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.kbAceptar)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Aceptar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.kbCancelar))
        ]
        textNombre.inputAccessoryView = toolBar
        textApaterno.inputAccessoryView = toolBar
        textAmaterno.inputAccessoryView = toolBar
    }
    
    func kbAceptar() {
        mostrarAviso(titulo: "Aviso", mensaje: "Aceptar", viewController: self)
    }
    
    func kbCancelar() {
        mostrarAviso(titulo: "Aviso", mensaje: "Cancelar", viewController: self)
    }
    
    @IBAction func guardarReferido(_ sender: UIButton) {
        referido["nombre"] = textNombre.text
        referido["apaterno"] = textApaterno.text
        referido["amaterno"] = textAmaterno.text
        referido["telefono"] = textTelefono.text
        if nuevo {
            ejecutarEnPersonas(accion: "insert", persona: referido)
        }
        else {
            ejecutarEnPersonas(accion: "update", persona: referido)
        }
    }
    
    @IBAction func eliminarReferido(_ sender: UIButton) {
        if !nuevo {
            ejecutarEnPersonas(accion: "delete", persona: referido)
        }
    }
    
    @IBAction func cancelar(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindReferido", sender: self)
    }

    @IBAction func unwindBuscar(sender: UIStoryboardSegue) {
     
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
