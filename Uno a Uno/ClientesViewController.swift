//
//  ClientesViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 25/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

var llamada: Bool = false
var llamada1: Bool = false

class ClientesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var tableClientes: UITableView!
    
    var idx: Int = -1
    var id: String = ""
    var nuevo: Bool = true
    var clientes: [[String:String]] = selectPersonas(esCliente: "1")
    var telefono: String = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableClientes.delegate = self
        tableClientes.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = clientes[indexPath.row]["nombrec"]!
        cell.detailTextLabel?.text = clientes[indexPath.row]["telefono"]!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idx = indexPath.row
        id = clientes[indexPath.row]["id"]!
        telefono = clientes[indexPath.row]["telefono"]!
    }
    
    @IBAction func addCliente(_ sender: UIButton) {
        nuevo = true
        self.performSegue(withIdentifier: "segueCliente", sender: self)
    }
    
    @IBAction func editCliente(_ sender: UIButton) {
        nuevo = false
        if idx >= 0 {
            self.performSegue(withIdentifier: "segueCliente", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if idx >= 0 && nuevo == false {
            let clienteVC = segue.destination as! ClienteViewController
            clienteVC.nuevo = false
            clienteVC.cliente["id"] = clientes[idx]["id"]
            clienteVC.cliente["nombre"] = clientes[idx]["nombre"]
            clienteVC.cliente["apaterno"] = clientes[idx]["apaterno"]
            clienteVC.cliente["amaterno"] = clientes[idx]["amaterno"]
            clienteVC.cliente["cliente"] = clientes[idx]["cliente"]
            clienteVC.cliente["direccion"] = clientes[idx]["direccion"]
            clienteVC.cliente["notas"] = clientes[idx]["notas"]
            clienteVC.cliente["referencia"] = clientes[idx]["referencia"]
        }
    }
    
    @IBAction func llamar(_ sender: UIButton) {
        if idx >= 0 {
            let popController = UIStoryboard(name: "iPhone", bundle: nil).instantiateViewController(withIdentifier: "popoverId")
            popController.modalPresentationStyle = UIModalPresentationStyle.popover
            popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
            popController.popoverPresentationController?.delegate = self
            popController.popoverPresentationController?.sourceView = sender as UIView
            popController.popoverPresentationController?.sourceRect = sender.bounds
            popController.setValue(id, forKey: "id")
            self.present(popController, animated: true, completion: nil)
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBAction func unwindCliente(sender: UIStoryboardSegue) {
        clientes = selectPersonas(esCliente: "1")
        tableClientes.reloadData()
        idx = -1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
