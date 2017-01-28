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
    var referidos: [[String:String]] = []
    var filtro: [[String:String]] = []
    let dicEstatus: [String] = ["Pendiente", "Llamada", "Cita", "Seguimiento", "No Interesado", "Todos"]
    let dicE: [String:String] = ["Pendiente":"PE", "Llamada":"LL", "Cita":"CT", "Seguimiento":"SE", "No Interesado":"NI", "Contrato":"CO", "Inactivo":"IN", "Todos":""]
    let dicEst: [String:String] = ["PE":"Pendiente", "LL":"Llamada", "CT":"Cita", "SE":"Seguimiento", "NI":"No Interesado", "CO":"Contrato", "IN":"Inactivo", "":"Todos"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchReferidos.delegate = self
        tableReferidos.delegate = self
        tableReferidos.dataSource = self
        pickerEstatus.delegate = self
        pickerEstatus.dataSource = self
        pickerEstatus.selectRow(5, inComponent: 0, animated: true)
    }
    
    func cargaDatos(completa: Bool) {
        if completa {
            referidos = selectPersonas(esCliente: "0")
        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        cargaDatos(completa: true)
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
        cargaDatos(completa: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        cargaDatos(completa: false)
        if searchBar.text == "" {
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
        let cell = CustomCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 20))
        cell.lblNombre.text = filtro[indexPath.row]["nombrec"]!
        cell.lblReferencia.text = filtro[indexPath.row]["referencia"]!
        cell.lblEstatus.text = dicEst[filtro[indexPath.row]["estatus"]!]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        cell.addGestureRecognizer(tap)
        
        let swipeL = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        swipeL.direction = UISwipeGestureRecognizerDirection.left
        cell.addGestureRecognizer(swipeL)
        
        let swipeR = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        swipeR.direction = UISwipeGestureRecognizerDirection.right
        cell.addGestureRecognizer(swipeR)
        
        return cell
    }
    
    func swipeLeft(i: UILongPressGestureRecognizer)  {
        if i.state == UIGestureRecognizerState.ended {
            let p: CGPoint = i.location(in: tableReferidos)
            let indexPath = tableReferidos.indexPathForRow(at: p)
            let cell: UITableViewCell = tableReferidos.cellForRow(at: indexPath!)!
            cell.accessoryType = .checkmark
        }
    }
    
    func swipeRight(i: UILongPressGestureRecognizer)  {
        if i.state == UIGestureRecognizerState.ended {
            let p: CGPoint = i.location(in: tableReferidos)
            let indexPath = tableReferidos.indexPathForRow(at: p)
            let cell: UITableViewCell = tableReferidos.cellForRow(at: indexPath!)!
            cell.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idx = indexPath.row
        id = filtro[indexPath.row]["id"]!
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
                executePersonas("DELETE", persona: filtro[i])
                deleteTelefonos(filtro[i]["id"]!)
                deleteCorreos(filtro[i]["id"]!)
            }
        }
        mostrarAviso(titulo: "", mensaje: "La información se eliminó correctamente", viewController: self)
        cargaDatos(completa: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueReferido" {
            if idx >= 0 && nuevo == false {
                let referidoVC = segue.destination as! ReferidoViewController
                referidoVC.nuevo = false
                referidoVC.id = filtro[idx]["id"]!
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
        cargaDatos(completa: true)
    }
    
    @IBAction func unwindReferidoDet(sender: UIStoryboardSegue) {
        cargaDatos(completa: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
