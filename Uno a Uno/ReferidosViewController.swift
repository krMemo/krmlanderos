//
//  ReferidosViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 26/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class ReferidosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableReferidos: UITableView!
    
    var nuevo: Bool = true
    var idx: Int = 0
    var referidos: [[String:String]] = selectPersonas(esCliente: "0")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableReferidos.delegate = self
        tableReferidos.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return referidos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        cell.textLabel?.text = referidos[indexPath.row]["nombre"]! + " " + referidos[indexPath.row]["apaterno"]!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idx = indexPath.row
    }
    
    @IBAction func addReferido(_ sender: UIButton) {
        nuevo = true
        self.performSegue(withIdentifier: "segueReferido", sender: self)
    }
    
    @IBAction func editReferido(_ sender: UIButton) {
        nuevo = false
        self.performSegue(withIdentifier: "segueReferido", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if !nuevo {
            let referidoVC = segue.destination as! ReferidoViewController
            referidoVC.nuevo = nuevo
            referidoVC.referido["id"] = referidos[idx]["id"]
            referidoVC.referido["nombre"] = referidos[idx]["nombre"]
            referidoVC.referido["apaterno"] = referidos[idx]["apaterno"]
            referidoVC.referido["amaterno"] = referidos[idx]["amaterno"]
            referidoVC.referido["telefono"] = referidos[idx]["telefono"]
        }
    }
    
    @IBAction func unwindReferido(sender: UIStoryboardSegue) {
        referidos = selectPersonas(esCliente: "N")
        tableReferidos.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
