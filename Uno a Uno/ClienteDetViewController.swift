//
//  ClienteDetViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 28/12/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class ClienteDetViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var labelNombre: UILabel!
    @IBOutlet weak var labelReferencia: UILabel!
    @IBOutlet weak var labelTelefono: UILabel!
    @IBOutlet weak var labelCorreo: UILabel!
    @IBOutlet weak var labelDireccion: UILabel!
    @IBOutlet weak var pickerEstatus: UIPickerView!
    @IBOutlet weak var tableSeguros: UITableView!
    
    var id: String = ""
    var idx: Int = -1
    var nuevoSeguro: Bool = true
    var seguros: [[String:String]] = []
    var cliente: [String:String] = [:]
    let dicEstatus: [Int:String] = [0:"Pendiente", 1:"Llamada", 2:"Cita", 3:"Seguimiento", 4:"No Interesado", 5:"Contrato", 6:"Inactivo"]
    let dicE: [String:String] = ["Pendiente":"PE", "Llamada":"LL", "Cita":"CT", "Seguimiento":"SE", "No Interesado":"NI", "Contrato":"CO", "Inactivo":"IN"]

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerEstatus.delegate = self
        pickerEstatus.dataSource = self
        tableSeguros.delegate = self
        tableSeguros.dataSource = self
        cliente = selectPersona(id)
        labelNombre.text = cliente["nombrec"]
        labelReferencia.text = cliente["referencia"]
        labelTelefono.text = cliente["telefono"]
        labelCorreo.text = cliente["correo"]
        labelDireccion.text = cliente["direccion"]
        for estatus in dicEstatus {
            if dicE[estatus.value] == cliente["estatus"] {
                pickerEstatus.selectRow(estatus.key, inComponent: 0, animated: true)
            }
        }
        seguros = selectSeguros(id)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dicE.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dicEstatus[row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seguros.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = seguros[indexPath.row]["aseguradora"]!
        cell.detailTextLabel?.text = seguros[indexPath.row]["planseguro"]!
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        cell.addGestureRecognizer(tap)
        return cell
    }
    
    func doubleTapped() {
        self.performSegue(withIdentifier: "segueClienteDet", sender: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idx = indexPath.row
    }
    
    @IBAction func guardarEstatus(_ sender: UIButton) {
        cliente["estatus"] = dicE[dicEstatus[pickerEstatus.selectedRow(inComponent: 0)]!]
        if cliente["estatus"] == "CO" || cliente["estatus"] == "IN" {
            cliente["cliente"] = "1"
            addHistorial(id, estatus: "CLI")
        }
        else {
            cliente["cliente"] = "0"
            addHistorial(id, estatus: "REF")
        }
        executePersonas("UPDATE", persona: cliente)
        addHistorial(id, estatus: cliente["estatus"]!)
        mostrarAviso(titulo: "Aviso", mensaje: "Se cambió el estratus correctamente.", viewController: self)
    }
    
    @IBAction func regresar(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindClienteDet", sender: self)
    }
    
    @IBAction func guardarSeguro(_ sender: UIButton) {
        nuevoSeguro = true
        self.performSegue(withIdentifier: "segueSeguros", sender: self)
    }
    
    @IBAction func editarSeguro(_ sender: UIButton) {
        nuevoSeguro = false
        performSegue(withIdentifier: "segueSeguros", sender: self)
    }
    
    @IBAction func editarCliente(_ sender: UIButton) {
        performSegue(withIdentifier: "segueCliDet", sender: self)
    }
    
    @IBAction func borrarCliente(_ sender: UIButton) {
        executePersonas("DELETE", persona: cliente)
        deleteTelefonos(id)
        deleteCorreos(id)
        mostrarAviso(titulo: "", mensaje: "La información se eliminó correctamente", viewController: self)
        self.performSegue(withIdentifier: "unwindClienteDet", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueSeguros" {
            let segurosVC = segue.destination as! SegurosViewController
            segurosVC.nuevo = nuevoSeguro
            segurosVC.id = id
            if idx >= 0 {
                segurosVC.idx = String(idx)
            }
        }
        else if segue.identifier == "segueCliDet" {
            let clienteVC = segue.destination as! ClienteViewController
            clienteVC.id = id
            clienteVC.nuevo = false
        }
    }
    
    @IBAction func unwindSeguros(sender: UIStoryboardSegue) {
        idx = -1
        seguros = selectSeguros(id)
        tableSeguros.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
