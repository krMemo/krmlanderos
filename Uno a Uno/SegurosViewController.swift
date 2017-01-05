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
    var idx: String = ""
    var nuevo: Bool = true
    var seguros: [[String:String]] = []
    var seguro: [String:String] = ["id":"", "idx":"", "aseguradora":"", "planseguro":"", "referencia":"", "poliza":"", "vigencia":"", "plazo":"", "formapago":"", "institucion":"", "periodicidad":""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seguros = selectSeguros(id)
        print(seguros)
        print(idx)
        print(nuevo)
        if nuevo {
            idx = String(seguros.count)
        }
        else {
            for xseguro in seguros {
                if xseguro["idx"] == idx {
                    txtAseguradora.text = xseguro["aseguradora"]
                    txtPlanSeguro.text = xseguro["planseguro"]
                    txtReferencia.text = xseguro["referencia"]
                    txtPoliza.text = xseguro["poliza"]
                    txtVigencia.text = xseguro["vigencia"]
                    txtPlazo.text = xseguro["plazo"]
                    txtFormaPago.text = xseguro["formapago"]
                    txtInstitucion.text = xseguro["institucion"]
                    txtPeriodicidad.text = xseguro["periodicidad"]
                }
            }
        }
    }
    
    @IBAction func guardar(_ sender: UIButton) {
        if nuevo {
            seguro["id"] = id
            seguro["idx"] = idx
            seguro["aseguradora"] = txtAseguradora.text
            seguro["planseguro"] = txtPlanSeguro.text
            seguro["referencia"] = txtReferencia.text
            seguro["poliza"] = txtPoliza.text
            seguro["vigencia"] = txtVigencia.text
            seguro["plazo"] = txtPlazo.text
            seguro["formapago"] = txtFormaPago.text
            seguro["institucion"] = txtInstitucion.text
            seguro["periodicidad"] = txtPeriodicidad.text
            seguros.append(seguro)
        }
        else {
            let i: Int = Int(idx)!
            seguros[i]["aseguradora"] = txtAseguradora.text
            seguros[i]["planseguro"] = txtPlanSeguro.text
            seguros[i]["referencia"] = txtReferencia.text
            seguros[i]["poliza"] = txtPoliza.text
            seguros[i]["vigencia"] = txtVigencia.text
            seguros[i]["plazo"] = txtPlazo.text
            seguros[i]["formapago"] = txtFormaPago.text
            seguros[i]["institucion"] = txtInstitucion.text
            seguros[i]["periodicidad"] = txtPeriodicidad.text
        }
        update(id, seguros: seguros)
        mostrarAviso(titulo: "Aviso", mensaje: "Los datos se guardaron exitosamente.", viewController: self)
        performSegue(withIdentifier: "unwindSeguros", sender: self)
    }
    
    @IBAction func regresar(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindSeguros", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
