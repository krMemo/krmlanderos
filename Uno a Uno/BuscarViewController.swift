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
    var persona: String = ""
    var id: String = ""
    var aceptar: Bool = true
    var personas: [[String:String]] = []
    var filtro: [[String:String]] = []
    var searchActive : Bool = false
    
    @IBOutlet weak var searchPersonas: UISearchBar!
    @IBOutlet weak var tablePersonas: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        personas = selectAllPersonas()
        personas.sort {$0["nombre"]! < $1["nombre"]!}
        searchPersonas.delegate = self
        tablePersonas.delegate = self
        tablePersonas.dataSource = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filtro = []
        for person in personas {
            if (person["nombre"]?.contains(searchBar.text!))! {
                filtro.append(person)
            }
        }
        filtro.sort {$0["nombre"]! < $1["nombre"]!}
        tablePersonas.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchActive = false
            tablePersonas.reloadData()
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
            return personas.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        if searchActive {
            cell.textLabel?.text = filtro[indexPath.row]["nombre"]!
        }
        else {
            cell.textLabel?.text = personas[indexPath.row]["nombre"]!
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchActive {
            persona = filtro[indexPath.row]["nombre"]!
            id = filtro[indexPath.row]["id"]!
        }
        else {
            persona = personas[indexPath.row]["nombre"]!
            id = personas[indexPath.row]["id"]!
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if aceptar {
            if CR == "C" {
                let clienteVC = segue.destination as! ClienteViewController
                clienteVC.textReferencia.text = persona
            }
            else if CR == "R" {
                let referidoVC = segue.destination as! ReferidoViewController
                referidoVC.textReferencia.text = persona
            }
            else {
                let eventoVC = segue.destination as! EventoViewController
                eventoVC.textPersona.text = persona
                eventoVC.idpersona = id
            }
        }
    }
    
    @IBAction func aceptar(_ sender: UIButton) {
        aceptar = true
        self.performSegue(withIdentifier: "unwindBuscar", sender: self)
    }
    
    @IBAction func cancelar(_ sender: UIButton) {
        aceptar = false
        self.performSegue(withIdentifier: "unwindBuscar", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
