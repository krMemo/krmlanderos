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
    var clientes: [[String:String]] = selectPersonas(esCliente: "1")
    var filtro: [[String:String]] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        searchClientes.delegate = self
        tableClientes.delegate = self
        tableClientes.dataSource = self
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filtro = []
        for cliente in clientes {
            if (cliente["nombrec"]?.contains(searchBar.text!))! {
                filtro.append(cliente)
            }
        }
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
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        if searchActive {
            cell.textLabel?.text = filtro[indexPath.row]["nombrec"]!
            cell.detailTextLabel?.text = filtro[indexPath.row]["referencia"]!
        }
        else {
            cell.textLabel?.text = clientes[indexPath.row]["nombrec"]!
            cell.detailTextLabel?.text = clientes[indexPath.row]["referencia"]!
        }
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
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
