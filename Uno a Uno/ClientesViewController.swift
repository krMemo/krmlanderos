//
//  ClientesViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 25/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class ClientesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var searchClientes: UISearchBar!
    @IBOutlet weak var tableClientes: UITableView!
    
    var idx: Int = -1
    var id: String = ""
    var nuevo: Bool = true
    var searchActive: Bool = false
    var clientes: [[String:String]] = []
    var filtro: [[String:String]] = []
    let dicEstatus: [String:String] = ["PE":"Pendiente", "LL":"Llamada", "CT":"Cita", "SE":"Seguimiento", "CO":"Contrato", "NI":"No Interesado"]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        searchClientes.delegate = self
        tableClientes.delegate = self
        tableClientes.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        clientes = selectPersonas(esCliente: "1")
        clientes.sort {$0["nombrec"]! < $1["nombrec"]!}
        tableClientes.reloadData()
        idx = -1
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
            cell.lblEstatus.text = dicEstatus[filtro[indexPath.row]["estatus"]!]
        }
        else {
            cell.lblNombre.text = clientes[indexPath.row]["nombrec"]!
            cell.lblReferencia.text = clientes[indexPath.row]["referencia"]!
            cell.lblEstatus.text = dicEstatus[clientes[indexPath.row]["estatus"]!]
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        cell.addGestureRecognizer(tap)
        return cell
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCliente" {
            if idx >= 0 && nuevo == false {
                let clienteVC = segue.destination as! ClienteViewController
                clienteVC.nuevo = nuevo
                clienteVC.id = id
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
