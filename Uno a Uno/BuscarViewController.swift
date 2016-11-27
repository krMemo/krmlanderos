//
//  BuscarViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 24/11/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class BuscarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var personas = selectAllPersonas()
    
    @IBOutlet weak var tablePersonas: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablePersonas.delegate = self
        tablePersonas.dataSource = self
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
        cell.detailTextLabel?.text = personas[indexPath.row]["id"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func aceptar(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindBuscar", sender: self)
    }
    
    @IBAction func cancelar(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindBuscar", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
