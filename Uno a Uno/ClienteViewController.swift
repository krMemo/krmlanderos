//
//  ClienteViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 28/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class ClienteViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {

    var id: String = ""
    var TC: String = ""
    var nuevo: Bool = true
    var cliente: [String:String] = ["id":"", "nombre":"", "apaterno":"", "amaterno":"", "direccion":"", "notas":"", "estatus":"", "cliente":"", "referencia":""]
    var telefonos: [[String:String]] = []
    var telefono: [String:String] = ["id":"", "idx":"", "principal":"", "telefono":"", "tipo":""]
    var correos: [[String:String]] = []
    var correo: [String:String] = ["id":"", "idx":"", "principal":"", "correo":"", "tipo":""]
    
    @IBOutlet weak var textNombre: UITextField!
    @IBOutlet weak var textApaterno: UITextField!
    @IBOutlet weak var textAmaterno: UITextField!
    @IBOutlet weak var textDireccion: UITextView!
    @IBOutlet weak var textNotas: UITextView!
    @IBOutlet weak var textReferencia: UITextField!
    @IBOutlet weak var tableTelefonos: UITableView!
    @IBOutlet weak var tableCorreos: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textNombre.delegate = self
        textApaterno.delegate = self
        textAmaterno.delegate = self
        textDireccion.delegate = self
        textNotas.delegate = self
        tableTelefonos.delegate = self
        tableTelefonos.dataSource = self
        tableCorreos.delegate = self
        tableCorreos.dataSource = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.kbCancelar)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Aceptar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.kbAceptar))
        ]
        
        textNotas.inputAccessoryView = toolBar

        if nuevo {
            id = selectMaxId(tabla: "personas")
        }
        else {
            id = cliente["id"]!
            textNombre.text = cliente["nombre"]
            textApaterno.text = cliente["apaterno"]
            textAmaterno.text = cliente["amaterno"]
            textDireccion.text = cliente["direccion"]
            textNotas.text = cliente["notas"]
            textReferencia.text = cliente["referencia"]
            telefonos = selectTefonos(id: id)
            correos = selectCorreos(id: id)
        }
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        if tableView == tableTelefonos {
            rows = telefonos.count
        }
        else if tableView == tableCorreos {
            rows = correos.count
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if tableView == tableTelefonos {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellTel")! as UITableViewCell
            if telefonos.count > 0 {
                cell.detailTextLabel?.text = telefonos[indexPath.row]["tipo"]!
                cell.textLabel?.text = telefonos[indexPath.row]["telefono"]!
            }
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellCor")! as UITableViewCell
            if correos.count > 0 {
                cell.detailTextLabel?.text = correos[indexPath.row]["tipo"]!
                cell.textLabel?.text = correos[indexPath.row]["correo"]!
            }
        }
        return cell
    }
    
    @IBAction func guardarCliente(_ sender: UIButton) {
        cliente["id"] = id
        cliente["nombre"] = textNombre.text
        cliente["apaterno"] = textApaterno.text
        cliente["amaterno"] = textAmaterno.text
        cliente["direccion"] = textDireccion.text
        cliente["notas"] = textNotas.text
        cliente["referencia"] = textReferencia.text
        cliente["cliente"] = "1"
        if nuevo {
            executePersonas(accion: "INSERT", persona: cliente)
        }
        else {
            executePersonas(accion: "UPDATE", persona: cliente)
        }
        update(telefonos: telefonos, id: id)
        update(correos: correos, id: id)
        mostrarAviso(titulo: "", mensaje: "La información se guardó correctamente", viewController: self)
        self.performSegue(withIdentifier: "unwindCliente", sender: self)
    }
    
    @IBAction func cancelar(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindCliente", sender: self)
    }
    
    @IBAction func eliminarCliente(_ sender: UIButton) {
        if !nuevo {
            executePersonas(accion: "DELETE", persona: cliente)
            deleteTelefonos(id: id)
            deleteCorreos(id: id)
            mostrarAviso(titulo: "", mensaje: "La información se eliminó correctamente", viewController: self)
            self.performSegue(withIdentifier: "unwindCliente", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueTelCor" {
            let telcorVC = segue.destination as! TelefonosCorreosViewController
            telcorVC.id = id
            telcorVC.TC = TC
            telcorVC.CR = "C"
            telcorVC.telefonos = telefonos
            telcorVC.correos = correos
        }
        else if segue.identifier == "segueBuscar" {
            let buscarVC = segue.destination as! BuscarViewController
            buscarVC.CR = "C"
        }
    }
    
    @IBAction func buscar(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueBuscar", sender: self)
    }
    
    @IBAction func editarTelefono(_ sender: UIButton) {
        TC = "T"
        performSegue(withIdentifier: "segueTelCor", sender: self)
    }
    
    @IBAction func editarCorreo(_ sender: UIButton) {
        TC = "C"
        performSegue(withIdentifier: "segueTelCor", sender: self)
    }
    
    @IBAction func unwindBuscar(sender: UIStoryboardSegue) {
    
    }

    @IBAction func unwindTelCor(sender: UIStoryboardSegue) {
        tableTelefonos.reloadData()
        tableCorreos.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
