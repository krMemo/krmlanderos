//
//  ClienteViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 28/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class ClienteViewController: UIViewController, UITextFieldDelegate {

    var nuevo: Bool = true
    var cliente: [String:String] = ["id":"", "nombre":"", "apaterno":"", "amaterno":"", "telefono":"", "estatus":""]
    
    @IBOutlet weak var textNombre: UITextField!
    @IBOutlet weak var textApaterno: UITextField!
    @IBOutlet weak var textAmaterno: UITextField!
    @IBOutlet weak var textTelefono: UITextField!
    @IBOutlet weak var textCorreo: UITextField!
    @IBOutlet weak var textNotas: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !nuevo {
            textNombre.text = cliente["nombre"]
            textApaterno.text = cliente["apaterno"]
            textAmaterno.text = cliente["amaterno"]
            textTelefono.text = cliente["telefono"]
        }
        textNombre.delegate = self
        textApaterno.delegate = self
        textAmaterno.delegate = self
        textTelefono.delegate = self
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.kbCancelar)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Aceptar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.kbAceptar))
        ]
        textNombre.inputAccessoryView = toolBar
        textApaterno.inputAccessoryView = toolBar
        textAmaterno.inputAccessoryView = toolBar
        textTelefono.inputAccessoryView = toolBar
        /*
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        */
    }
    
    func kbAceptar() {
        self.view.endEditing(true)
    }
    
    func kbCancelar() {
        self.view.endEditing(true)
    }
    
    @IBAction func guardarCliente(_ sender: UIButton) {
        cliente["nombre"] = textNombre.text
        cliente["apaterno"] = textApaterno.text
        cliente["amaterno"] = textAmaterno.text
        cliente["telefono"] = textTelefono.text
        
        if nuevo {
            ejecutarEnPersonas(accion: "insert", persona: cliente)
        }
        else {
            ejecutarEnPersonas(accion: "update", persona: cliente)
        }
    }
    
    @IBAction func cancelar(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindCliente", sender: self)
    }
    
    @IBAction func eliminarCliente(_ sender: UIButton) {
        if !nuevo {
            ejecutarEnPersonas(accion: "delete", persona: cliente)
        }
    }

    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func buscar(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueBuscar", sender: self)
    }
    
    @IBAction func unwindBuscar(sender: UIStoryboardSegue) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
