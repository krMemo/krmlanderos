//
//  ClientesViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 25/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class ClientesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableClientes: UITableView!
    
    var nuevo: Bool = true
    var idx: Int = 0
    var clientes: [[String:String]] = selectAllClientes()
        
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
        
        cell.textLabel?.text = clientes[indexPath.row]["nombre"]! + " " + clientes[indexPath.row]["apaterno"]!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idx = indexPath.row
    }
    
    @IBAction func addCliente(_ sender: UIButton) {
        nuevo = true
        self.performSegue(withIdentifier: "segueCliente", sender: self)
    }
    
    @IBAction func editCliente(_ sender: UIButton) {
        nuevo = false
        self.performSegue(withIdentifier: "segueCliente", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if !nuevo {
            let clienteVC = segue.destination as! ClienteViewController
            clienteVC.nuevo = nuevo
            clienteVC.cliente["id"] = clientes[idx]["id"]
            clienteVC.cliente["nombre"] = clientes[idx]["nombre"]
            clienteVC.cliente["apaterno"] = clientes[idx]["apaterno"]
            clienteVC.cliente["amaterno"] = clientes[idx]["amaterno"]
            clienteVC.cliente["telefono"] = clientes[idx]["telefono"]
        }
    }
    
    @IBAction func unwindCliente(sender: UIStoryboardSegue) {
        clientes = selectAllClientes()
        tableClientes.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
