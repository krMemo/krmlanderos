//
//  ReferidosViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 26/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class ReferidosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var searchReferidos: UISearchBar!
    @IBOutlet weak var tableReferidos: UITableView!
    @IBOutlet weak var pickerEstatus: UIPickerView!
    
    var idx: Int = -1
    var id: String = ""
    var nuevo: Bool = true
    var searchActive: Bool = false
    var referidos: [[String:String]] = []
    var filtro: [[String:String]] = []
    let dicEstatus: [String] = ["Pendiente", "Llamada", "Cita", "Seguimiento", "No Interesado", ""]
    let dicE: [String:String] = ["Pendiente":"PE", "Llamada":"LL", "Cita":"CT", "Seguimiento":"SE", "No Interesado":"NI", "Contrato":"CO", "Inactivo":"IN", "":""]
    let dicEst: [String:String] = ["PE":"Pendiente", "LL":"Llamada", "CT":"Cita", "SE":"Seguimiento", "NI":"No Interesado", "CO":"Contrato", "IN":"Inactivo", "":""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchReferidos.delegate = self
        tableReferidos.delegate = self
        tableReferidos.dataSource = self
        pickerEstatus.delegate = self
        pickerEstatus.dataSource = self
        pickerEstatus.selectRow(5, inComponent: 0, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        referidos = selectPersonas(esCliente: "0")
        filtro = []
        let str = searchReferidos.text!
        let est = dicE[dicEstatus[pickerEstatus.selectedRow(inComponent: 0)]]
        for referido in referidos {
            if est == "" && str == "" {
                filtro.append(referido)
            }
            else if est == "" {
                if (referido["nombrec"]?.contains(str))! {
                    filtro.append(referido)
                }
            }
            else if str == "" {
                if est == referido["estatus"] {
                    filtro.append(referido)
                }
            }
            else {
                if (referido["nombrec"]?.contains(str))! && est == referido["estatus"] {
                    filtro.append(referido)
                }
            }
        }
        filtro.sort {$0["nombrec"]! < $1["nombrec"]!}
        tableReferidos.reloadData()
        idx = -1
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.text = dicEstatus[row]
        return titleLabel
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dicEstatus.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dicEstatus[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        searchReferidos.text = ""
        if dicE[dicEstatus[row]] == "" {
            searchActive = false
            tableReferidos.reloadData()
        }
        else {
            filtro = []
            for referido in referidos {
                if referido["estatus"] == dicE[dicEstatus[row]] {
                    filtro.append(referido)
                }
            }
            searchActive = true
            tableReferidos.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let str = searchBar.text!
        let est = dicE[dicEstatus[pickerEstatus.selectedRow(inComponent: 0)]]
        filtro = []
        for referido in referidos {
            if est == "" {
                if (referido["nombrec"]?.contains(str))! {
                    filtro.append(referido)
                }
            }
            else {
                if (referido["nombrec"]?.contains(str))! && est == referido["estatus"] {
                    filtro.append(referido)
                }
            }
        }
        filtro.sort {$0["nombrec"]! < $1["nombrec"]!}
        tableReferidos.reloadData()
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchActive = false
            self.view.endEditing(true)
        }
        else {
            searchActive = true
        }
        let str = searchReferidos.text!
        let est = dicE[dicEstatus[pickerEstatus.selectedRow(inComponent: 0)]]
        filtro = []
        for referido in referidos {
            if est == "" {
                if (referido["nombrec"]?.contains(str))! {
                    filtro.append(referido)
                }
            }
            else {
                if (referido["nombrec"]?.contains(str))! && est == referido["estatus"] {
                    filtro.append(referido)
                }
            }
        }
        filtro.sort {$0["nombrec"]! < $1["nombrec"]!}
        tableReferidos.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filtro.count
        }
        else {
            return referidos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CustomCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 20))
        if searchActive {
            cell.lblNombre.text = filtro[indexPath.row]["nombrec"]!
            cell.lblReferencia.text = filtro[indexPath.row]["referencia"]!
            cell.lblEstatus.text = dicEst[filtro[indexPath.row]["estatus"]!]
        }
        else {
            cell.lblNombre.text = referidos[indexPath.row]["nombrec"]!
            cell.lblReferencia.text = referidos[indexPath.row]["referencia"]!
            cell.lblEstatus.text = dicEst[referidos[indexPath.row]["estatus"]!]
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        cell.addGestureRecognizer(tap)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeR))
        swipe.direction = UISwipeGestureRecognizerDirection.left
        cell.addGestureRecognizer(swipe)
        
        return cell
    }
    
    func swipeR(i: UILongPressGestureRecognizer)  {
        if i.state == UIGestureRecognizerState.ended {
            let p: CGPoint = i.location(in: tableReferidos)
            let indexPath = tableReferidos.indexPathForRow(at: p)
            let cell: UITableViewCell = tableReferidos.cellForRow(at: indexPath!)!
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
            }
            else {
                cell.accessoryType = .checkmark
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idx = indexPath.row
        if searchActive {
            id = filtro[indexPath.row]["id"]!
        }
        else {
            id = referidos[indexPath.row]["id"]!
        }
    }
    
    func doubleTapped() {
        self.performSegue(withIdentifier: "segueReferidoDet", sender: self)
    }
    
    @IBAction func addReferido(_ sender: UIButton) {
        nuevo = true
        self.performSegue(withIdentifier: "segueReferido", sender: self)
    }
    
    @IBAction func editReferido(_ sender: UIButton) {
        nuevo = false
        if idx >= 0 {
            self.performSegue(withIdentifier: "segueReferido", sender: self)
        }
    }
    
    @IBAction func deleteReferido(_ sender: UIButton) {
        for i in 0 ..< tableReferidos.numberOfRows(inSection: 0) {
            let cell = tableReferidos.cellForRow(at: IndexPath(row: i, section: 0))
            if cell?.accessoryType == .checkmark {
                print(IndexPath(row: i, section: 0))
                if searchActive {
                    executePersonas("DELETE", persona: filtro[i])
                    deleteTelefonos(filtro[i]["id"]!)
                    deleteCorreos(filtro[i]["id"]!)
                }
                else {
                    executePersonas("DELETE", persona: referidos[i])
                    deleteTelefonos(referidos[i]["id"]!)
                    deleteCorreos(referidos[i]["id"]!)
                }
            }
        }
        searchActive = false
        referidos = selectPersonas(esCliente: "0")
        referidos.sort {$0["nombrec"]! < $1["nombrec"]!}
        tableReferidos.reloadData()
        idx = -1
        mostrarAviso(titulo: "", mensaje: "La información se eliminó correctamente", viewController: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueReferido" {
            if idx >= 0 && nuevo == false {
                let referidoVC = segue.destination as! ReferidoViewController
                if searchActive {
                    referidoVC.nuevo = false
                    referidoVC.id = filtro[idx]["id"]!
                }
                else {
                    referidoVC.nuevo = false
                    referidoVC.id = referidos[idx]["id"]!
                }
            }
        }
        else if segue.identifier == "segueReferidoDet" {
            let referidoDetVC = segue.destination as! ReferidoDetViewController
            referidoDetVC.id = id
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
    
    @IBAction func unwindReferido(sender: UIStoryboardSegue) {
        referidos = selectPersonas(esCliente: "0")
        tableReferidos.reloadData()
        idx = -1
    }
    
    @IBAction func unwindReferidoDet(sender: UIStoryboardSegue) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
