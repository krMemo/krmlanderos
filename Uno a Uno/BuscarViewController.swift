//
//  BuscarViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 24/11/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class BuscarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var CR: String = ""
    var nombre: String = ""
    var id: String = ""
    var aceptar: Bool = true
    var personas: [[String:String]] = []
    var filtro: [[String:String]] = []
    
    @IBOutlet weak var searchPersonas: UISearchBar!
    @IBOutlet weak var tablePersonas: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchPersonas.delegate = self
        tablePersonas.delegate = self
        tablePersonas.dataSource = self
        cargarDatos()
    }
    
    func cargarDatos() {
        id = ""
        let str = searchPersonas.text
        personas = selectAllPersonas()
        filtro = []
        for persona in personas {
            if str != "" {
                if (persona["nombre"]?.contains(str!))! {
                    filtro.append(persona)
                }
            }
            else {
                filtro.append(persona)
            }
        }
        filtro.sort {$0["nombre"]! < $1["nombre"]!}
        tablePersonas.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        cargarDatos()
        if searchText == "" {
            self.view.endEditing(true)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtro.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = filtro[indexPath.row]["nombre"]!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nombre = filtro[indexPath.row]["nombre"]!
        id = filtro[indexPath.row]["id"]!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if aceptar {
            if CR == "C" {
                let clienteVC = segue.destination as! ClienteViewController
                clienteVC.textReferencia.text = nombre
            }
            else if CR == "R" {
                let referidoVC = segue.destination as! ReferidoViewController
                referidoVC.textReferencia.text = nombre
            }
            else {
                let eventoVC = segue.destination as! EventoViewController
                eventoVC.textPersona.text = nombre
                eventoVC.idpersona = id
            }
        }
    }
    
    @IBAction func aceptar(_ sender: UIButton) {
        if id != "" {
            aceptar = true
            self.performSegue(withIdentifier: "unwindBuscar", sender: self)
        }
    }
    
    @IBAction func cancelar(_ sender: UIButton) {
        aceptar = false
        self.performSegue(withIdentifier: "unwindBuscar", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
