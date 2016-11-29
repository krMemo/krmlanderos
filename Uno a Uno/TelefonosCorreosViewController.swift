//
//  TelefonosCorreosViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 27/11/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class TelefonosCorreosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var id: String = ""
    var idx: Int = 0
    var TC: String = ""
    var CR: String = ""
    var telefonos: [[String:String]] = []
    var telefono: [String:String] = ["id":"", "idx":"", "principal":"", "telefono":"", "tipo":""]
    var correos: [[String:String]] = []
    var correo: [String:String] = ["id":"", "idx":"", "principal":"", "correo":"", "tipo":""]
    
    @IBOutlet weak var labelTelCor: UILabel!
    @IBOutlet weak var textTelCor: UITextField!
    @IBOutlet weak var tableTelCor: UITableView!
    @IBOutlet weak var textTipo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableTelCor.delegate = self
        tableTelCor.dataSource = self
        if TC == "T" {
            labelTelCor.text = "Teléfono"
        }
        else if TC == "C" {
            labelTelCor.text = "Correo"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        if TC == "T" {
            rows = telefonos.count
        }
        else if TC == "C" {
            rows = correos.count
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        if TC == "T" {
            telefonos[indexPath.row]["idx"] = String(indexPath.row)
            cell.textLabel?.text = telefonos[indexPath.row]["telefono"]!
            cell.detailTextLabel?.text = telefonos[indexPath.row]["tipo"]!
            cell.accessoryType = telefonos[indexPath.row]["principal"] == "1" ? .checkmark : .none
        }
        else if TC == "C" {
            correos[indexPath.row]["idx"] = String(indexPath.row)
            cell.textLabel?.text = correos[indexPath.row]["correo"]!
            cell.detailTextLabel?.text = correos[indexPath.row]["tipo"]!
            cell.accessoryType = correos[indexPath.row]["principal"] == "1" ? .checkmark : .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                if TC == "T" {
                    telefonos[indexPath.row]["principal"] = "0"
                }
                else if TC == "C" {
                    correos[indexPath.row]["principal"] = "0"
                }
            }
            else {
                cell.accessoryType = .checkmark
                if TC == "T" {
                    telefonos[indexPath.row]["principal"] = "1"
                }
                else if TC == "C" {
                    correos[indexPath.row]["principal"] = "1"
                }
            }
        }
        idx = indexPath.row
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if CR == "C" {
            let clienteVC = segue.destination as! ClienteViewController
            clienteVC.telefonos = telefonos
            clienteVC.correos = correos
        }
        else if CR == "R" {
            let referidoVC = segue.destination as! ReferidoViewController
            referidoVC.telefonos = telefonos
            referidoVC.correos = correos
        }
    }
    
    @IBAction func addTelCor(_ sender: UIButton) {
        if TC == "T" {
            telefono["id"] = id
            telefono["idx"] = String(telefonos.count)
            telefono["telefono"] = textTelCor.text
            telefono["tipo"] = textTipo.text
            telefono["principal"] = "0"
            telefonos.append(telefono)
        }
        else if TC == "C" {
            correo["id"] = id
            correo["idx"] = String(correos.count)
            correo["correo"] = textTelCor.text
            correo["tipo"] = textTipo.text
            correo["principal"] = "0"
            correos.append(correo)
        }
        tableTelCor.reloadData()
    }
    
    @IBAction func delTelCor(_ sender: UIButton) {
        
    }
    
    @IBAction func cancelar(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindTelCor", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
