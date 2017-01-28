//
//  TelefonosCorreosViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 27/11/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class TelefonosCorreosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var id: String = ""
    var idx: Int = -1
    var TC: String = ""
    var CR: String = ""
    var telefonos: [[String:String]] = []
    var telefono: [String:String] = ["id":"", "idx":"", "principal":"", "telefono":"", "tipo":""]
    var correos: [[String:String]] = []
    var correo: [String:String] = ["id":"", "idx":"", "principal":"", "correo":"", "tipo":""]
    let dicTipo: [String] = ["Casa", "Trabajo", "Móvil", "Otro"]
    
    @IBOutlet weak var labelTelCor: UILabel!
    @IBOutlet weak var textTelCor: UITextField!
    @IBOutlet weak var tableTelCor: UITableView!
    @IBOutlet weak var pickerTipo: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableTelCor.delegate = self
        tableTelCor.dataSource = self
        pickerTipo.delegate = self
        pickerTipo.dataSource = self
        if TC == "T" {
            labelTelCor.text = "Teléfono"
        }
        else if TC == "C" {
            labelTelCor.text = "Correo"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.text = dicTipo[row]
        return titleLabel
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dicTipo.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dicTipo[row]
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
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(longTapped))
        cell.addGestureRecognizer(tap)
        return cell
    }
    
    func longTapped(i: UILongPressGestureRecognizer)  {
        if i.state == UIGestureRecognizerState.began {
            let p: CGPoint = i.location(in: tableTelCor)
            let indexPath = tableTelCor.indexPathForRow(at: p)
            var i: Int = 0
            if TC == "T" {
                for _ in telefonos {
                    telefonos[i]["principal"] = indexPath?.row == i ? "1" : "0"
                    i += 1
                }
            }
            else if TC == "C" {
                for _ in correos {
                    correos[i]["principal"] = indexPath?.row == i ? "1" : "0"
                    i += 1
                }
            }
            tableTelCor.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idx = indexPath.row
        if TC == "T" {
            textTelCor.text = telefonos[idx]["telefono"]
            pickerTipo.selectRow(getRow(telefonos[idx]["tipo"]!), inComponent: 0, animated: true)
        }
        else if TC == "C" {
            textTelCor.text = correos[idx]["correo"]
            pickerTipo.selectRow(getRow(correos[idx]["tipo"]!), inComponent: 0, animated: true)
        }
    }
    
    func getRow(_ tipo: String) -> Int {
        var i: Int = 0
        for item in dicTipo {
            if tipo == item {
                return i
            }
            i += 1
        }
        return 0
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
            telefono["telefono"] = textTelCor.text
            telefono["tipo"] = dicTipo[pickerTipo.selectedRow(inComponent: 0)]
            telefono["principal"] = "0"
            telefonos.append(telefono)
        }
        else if TC == "C" {
            correo["id"] = id
            correo["correo"] = textTelCor.text
            correo["tipo"] = dicTipo[pickerTipo.selectedRow(inComponent: 0)]
            correo["principal"] = "0"
            correos.append(correo)
        }
        tableTelCor.reloadData()
        textTelCor.text = ""
        pickerTipo.selectRow(0, inComponent: 0, animated: true)
        idx = -1
    }
    
    @IBAction func editTelCor(_ sender: UIButton) {
        if idx >= 0 {
            if TC == "T" {
                telefono["id"] = id
                telefono["telefono"] = textTelCor.text
                telefono["tipo"] = dicTipo[pickerTipo.selectedRow(inComponent: 0)]
                telefono["principal"] = "0"
                telefonos.remove(at: idx)
                telefonos.append(telefono)
            }
            else if TC == "C" {
                correo["id"] = id
                correo["correo"] = textTelCor.text
                correo["tipo"] = dicTipo[pickerTipo.selectedRow(inComponent: 0)]
                correo["principal"] = "0"
                correos.remove(at: idx)
                correos.append(correo)
            }
            tableTelCor.reloadData()
            textTelCor.text = ""
            pickerTipo.selectRow(0, inComponent: 0, animated: true)
            idx = -1
        }
    }
    
    @IBAction func delTelCor(_ sender: UIButton) {
        if idx >= 0 {
            telefonos.remove(at: idx)
            tableTelCor.reloadData()
        }
    }
    
    @IBAction func cancelar(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindTelCor", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
