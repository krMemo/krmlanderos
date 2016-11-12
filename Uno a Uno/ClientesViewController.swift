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

class ClientesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableClientes: UITableView!
    
    var nuevo: Bool = true
    var idx: Int = 0
    var clientes: [[String:String]] = selectAllClientes()
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
        cell.detailTextLabel?.text = clientes[indexPath.row]["telefono"]!
        cell.textLabel?.text = clientes[indexPath.row]["nombre"]! + " " + clientes[indexPath.row]["apaterno"]!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idx = indexPath.row
        telefono = clientes[indexPath.row]["telefono"]!
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
    
    @IBAction func llamar(_ sender: UIButton) {
        if let url = NSURL(string: "tel://\(telefono)") {
            
            UIApplication.shared.open(url as URL, options: [:], completionHandler: {
                (success) in
                print("Open \(success)")
                llamada = true
                if llamada1 {
                    mostrarAviso(titulo: "x", mensaje: "llamada", viewController: self)
                }
            })
            UIApplication.shared.completeStateRestoration()
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
