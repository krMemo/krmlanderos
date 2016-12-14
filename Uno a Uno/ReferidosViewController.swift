//
//  ReferidosViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 26/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class ReferidosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var tableReferidos: UITableView!
    
    var idx: Int = -1
    var id: String = ""
    var nuevo: Bool = true
    var referidos: [[String:String]] = selectPersonas(esCliente: "0")
    var telefono: String = ""
    
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
        cell.textLabel?.text = referidos[indexPath.row]["nombrec"]!
        cell.detailTextLabel?.text = referidos[indexPath.row]["telefono"]!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idx = indexPath.row
        id = referidos[indexPath.row]["id"]!
        telefono = referidos[indexPath.row]["telefono"]!
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
