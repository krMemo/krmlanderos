//
//  LlamadaViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 13/12/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class LlamadaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableTelefonos: UITableView!
    
    var id: String = ""
    var telefonos: [[String:String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableTelefonos.delegate = self
        tableTelefonos.dataSource = self
        id = self.value(forKey: "id") as! String
        telefonos = selectTefonos(id: id)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return telefonos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        if telefonos.count > 0 {
            cell.detailTextLabel?.text = telefonos[indexPath.row]["telefono"]!
            cell.textLabel?.text = telefonos[indexPath.row]["tipo"]!
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let telefono = telefonos[indexPath.row]["telefono"]!
        if let url = NSURL(string: "tel://\(telefono)") {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: {
                (success) in
                print("Open \(success)")
            })
            UIApplication.shared.completeStateRestoration()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
