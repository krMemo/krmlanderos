//
//  ReferidosViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 26/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class ReferidosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var searchReferidos: UISearchBar!
    @IBOutlet weak var tableReferidos: UITableView!
    
    var idx: Int = -1
    var id: String = ""
    var nuevo: Bool = true
    var searchActive: Bool = false
    var referidos: [[String:String]] = selectPersonas(esCliente: "0")
    var filtro: [[String:String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchReferidos.delegate = self
        tableReferidos.delegate = self
        tableReferidos.dataSource = self
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filtro = []
        for referido in referidos {
            if (referido["nombrec"]?.contains(searchBar.text!))! {
                filtro.append(referido)
            }
        }
        tableReferidos.reloadData()
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchActive = false
            tableReferidos.reloadData()
            self.view.endEditing(true)
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
            return referidos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        if searchActive {
            cell.textLabel?.text = filtro[indexPath.row]["nombrec"]!
            cell.detailTextLabel?.text = filtro[indexPath.row]["referencia"]!
        }
        else {
            cell.textLabel?.text = referidos[indexPath.row]["nombrec"]!
            cell.detailTextLabel?.text = referidos[indexPath.row]["referencia"]!
        }
        return cell
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if idx >= 0 && nuevo == false {
            let referidoVC = segue.destination as! ReferidoViewController
            if searchActive {
                referidoVC.nuevo = false
                referidoVC.referido["id"] = filtro[idx]["id"]
                referidoVC.referido["nombre"] = filtro[idx]["nombre"]
                referidoVC.referido["apaterno"] = filtro[idx]["apaterno"]
                referidoVC.referido["amaterno"] = filtro[idx]["amaterno"]
                referidoVC.referido["cliente"] = filtro[idx]["cliente"]
                referidoVC.referido["direccion"] = filtro[idx]["direccion"]
                referidoVC.referido["notas"] = filtro[idx]["notas"]
                referidoVC.referido["referencia"] = filtro[idx]["referencia"]
            }
            else {
                referidoVC.nuevo = false
                referidoVC.referido["id"] = referidos[idx]["id"]
                referidoVC.referido["nombre"] = referidos[idx]["nombre"]
                referidoVC.referido["apaterno"] = referidos[idx]["apaterno"]
                referidoVC.referido["amaterno"] = referidos[idx]["amaterno"]
                referidoVC.referido["cliente"] = referidos[idx]["cliente"]
                referidoVC.referido["direccion"] = referidos[idx]["direccion"]
                referidoVC.referido["notas"] = referidos[idx]["notas"]
                referidoVC.referido["referencia"] = referidos[idx]["referencia"]
            }
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
