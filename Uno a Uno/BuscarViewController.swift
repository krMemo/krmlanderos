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
    var personas = selectAllPersonas()
    var searchActive : Bool = false
    var filtered = selectAllPersonas()
    
    @IBOutlet weak var searchPersonas: UISearchBar!
    @IBOutlet weak var tablePersonas: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchPersonas.delegate = self
        tablePersonas.delegate = self
        tablePersonas.dataSource = self
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        /*filtered = personas.filter({
            (text) -> Bool in
            let tmp = text
            //let range = tmp.rangeOfString(searchText, options: NSString.CompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })*/
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        tablePersonas.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = personas[indexPath.row]["nombre"]!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        persona = personas[indexPath.row]["nombre"]!
        id = personas[indexPath.row]["id"]!
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
                eventoVC.id = id
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
