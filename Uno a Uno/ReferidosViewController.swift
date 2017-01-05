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
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        cell.addGestureRecognizer(tap)
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
