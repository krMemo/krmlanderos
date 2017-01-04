//
//  SegurosViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 04/01/17.
//  Copyright © 2017 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class SegurosViewController: UIViewController {

    @IBOutlet weak var txtAseguradora: UITextField!
    @IBOutlet weak var txtPlanSeguro: UITextField!
    @IBOutlet weak var txtReferencia: UITextField!
    @IBOutlet weak var txtPoliza: UITextField!
    @IBOutlet weak var txtVigencia: UITextField!
    @IBOutlet weak var txtPlazo: UITextField!
    @IBOutlet weak var txtFormaPago: UITextField!
    @IBOutlet weak var txtInstitucion: UITextField!
    @IBOutlet weak var txtPeriodicidad: UITextField!
    
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
