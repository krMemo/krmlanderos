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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = "hola"
        return cell
    }
    
    @IBAction func addReferido(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueReferido", sender: self)
    }
    
    @IBAction func editReferido(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueReferido", sender: self)
    }
    
    @IBAction func unwindReferido(sender: UIStoryboardSegue)
    {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
