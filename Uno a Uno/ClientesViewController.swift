//
//  ClientesViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 25/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class ClientesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var searchClientes: UISearchBar!
    @IBOutlet weak var tableClientes: UITableView!
    @IBOutlet weak var pickerEstatus: UIPickerView!
    
    var idx: Int = -1
    var id: String = ""
    var nuevo: Bool = true
    var searchActive: Bool = false
    var clientes: [[String:String]] = []
    var filtro: [[String:String]] = []
    let dicEstatus: [String] = ["Contrato", "Inactivo", ""]
    let dicE: [String:String] = ["Pendiente":"PE", "Llamada":"LL", "Cita":"CT", "Seguimiento":"SE", "No Interesado":"NI", "Contrato":"CO", "Inactivo":"IN", "":""]
    let dicEst: [String:String] = ["PE":"Pendiente", "LL":"Llamada", "CT":"Cita", "SE":"Seguimiento", "NI":"No Interesado", "CO":"Contrato", "IN":"Inactivo", "":""]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        searchClientes.delegate = self
        tableClientes.delegate = self
        tableClientes.dataSource = self
        pickerEstatus.delegate = self
        pickerEstatus.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        pickerEstatus.selectRow(2, inComponent: 0, animated: true)
        searchActive = false
        clientes = selectPersonas(esCliente: "1")
        clientes.sort {$0["nombrec"]! < $1["nombrec"]!}
        tableClientes.reloadData()
        idx = -1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.text = dicEstatus[row]
        return titleLabel
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dicEstatus.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dicEstatus[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        searchClientes.text = ""
        if dicE[dicEstatus[row]] == "" {
            searchActive = false
            tableClientes.reloadData()
        }
        else {
            filtro = []
            for cliente in clientes {
                if cliente["estatus"] == dicE[dicEstatus[row]] {
                    filtro.append(cliente)
                }
            }
            searchActive = true
            tableClientes.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filtro = []
        for cliente in clientes {
            if (cliente["nombrec"]?.contains(searchBar.text!))! {
                filtro.append(cliente)
            }
        }
        filtro.sort {$0["nombrec"]! < $1["nombrec"]!}
        tableClientes.reloadData()
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            pickerEstatus.selectRow(2, inComponent: 0, animated: true)
            searchActive = false
            tableClientes.reloadData()
            self.view.endEditing(true)
        }
        else {
            searchActive = true
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filtro.count
        }
        else {
            return clientes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CustomCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 20))
        if searchActive {
            cell.lblNombre.text = filtro[indexPath.row]["nombrec"]!
            cell.lblReferencia.text = filtro[indexPath.row]["referencia"]!
            cell.lblEstatus.text = dicEst[filtro[indexPath.row]["estatus"]!]
        }
        else {
            cell.lblNombre.text = clientes[indexPath.row]["nombrec"]!
            cell.lblReferencia.text = clientes[indexPath.row]["referencia"]!
            cell.lblEstatus.text = dicEst[clientes[indexPath.row]["estatus"]!]
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        cell.addGestureRecognizer(tap)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeR))
        swipe.direction = UISwipeGestureRecognizerDirection.left
        cell.addGestureRecognizer(swipe)
        
        return cell
    }
    
    func swipeR(i: UILongPressGestureRecognizer)  {
        if i.state == UIGestureRecognizerState.ended {
            let p: CGPoint = i.location(in: tableClientes)
            let indexPath = tableClientes.indexPathForRow(at: p)
            let cell: UITableViewCell = tableClientes.cellForRow(at: indexPath!)!
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
            }
            else {
                cell.accessoryType = .checkmark
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idx = indexPath.row
        if searchActive {
            id = filtro[indexPath.row]["id"]!
        }
        else {
            id = clientes[indexPath.row]["id"]!
        }
    }
    
    func doubleTapped() {
        self.performSegue(withIdentifier: "segueClienteDet", sender: self)
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
    
    @IBAction func deleteCliente(_ sender: UIButton) {
        for i in 0 ..< tableClientes.numberOfRows(inSection: 0) {
            let cell = tableClientes.cellForRow(at: IndexPath(row: i, section: 0))
            if cell?.accessoryType == .checkmark {
                print(IndexPath(row: i, section: 0))
                if searchActive {
                    executePersonas("DELETE", persona: filtro[i])
                    deleteTelefonos(filtro[i]["id"]!)
                    deleteCorreos(filtro[i]["id"]!)
                }
                else {
                    executePersonas("DELETE", persona: clientes[i])
                    deleteTelefonos(clientes[i]["id"]!)
                    deleteCorreos(clientes[i]["id"]!)
                }
            }
        }
        searchActive = false
        clientes = selectPersonas(esCliente: "0")
        clientes.sort {$0["nombrec"]! < $1["nombrec"]!}
        tableClientes.reloadData()
        idx = -1
        mostrarAviso(titulo: "", mensaje: "La información se eliminó correctamente", viewController: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCliente" {
            if idx >= 0 && nuevo == false {
                let clienteVC = segue.destination as! ClienteViewController
                if searchActive {
                    clienteVC.nuevo = false
                    clienteVC.id = filtro[idx]["id"]!
                }
                else {
                    clienteVC.nuevo = false
                    clienteVC.id = clientes[idx]["id"]!
                }
            }
        }
        else if segue.identifier == "segueClienteDet" {
            let clienteDetVC = segue.destination as! ClienteDetViewController
            clienteDetVC.id = id
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
    
    @IBAction func unwindClienteDet(sender: UIStoryboardSegue) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
