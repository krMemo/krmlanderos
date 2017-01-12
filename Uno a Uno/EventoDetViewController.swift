//
//  EventoDetViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 11/01/17.
//  Copyright © 2017 Enrique Landeros Reyes. All rights reserved.
//

import UIKit
import EventKit

class EventoDetViewController: UIViewController {

    @IBOutlet weak var labelPersona: UILabel!
    @IBOutlet weak var labelCorreo: UILabel!
    @IBOutlet weak var labelUbicacion: UILabel!
    @IBOutlet weak var labelNotas: UILabel!
    @IBOutlet weak var labelReferencia: UILabel!
    @IBOutlet weak var labelCalendario: UILabel!
    @IBOutlet weak var labelFecha: UILabel!
    @IBOutlet weak var labelTipo: UILabel!
    
    let eventStore = EKEventStore()
    var id: String = ""
    let dicT: [String:String] = ["LL":"Llamada", "CT":"Cita", "SE":"Seguimiento", "TA":"Tarea", "CO":"Confirmación", "CU":"Cumpleaños"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let df = DateFormatter()
        let tmpevento = selectEvento(id)
        print("carga: \(tmpevento)")
        if tmpevento["id"] == "" {
            let event = eventStore.event(withIdentifier: id)
            labelPersona.text = event?.title
            labelUbicacion.text = event?.location
            labelNotas.text = event?.notes
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            labelFecha.text = df.string(from: (event?.startDate)!)
            labelCalendario.text = event?.calendar.title
        }
        else {
            labelPersona.text = tmpevento["evento"]
            labelCorreo.text = tmpevento["correo"]
            labelNotas.text = tmpevento["notas"]
            labelUbicacion.text = tmpevento["ubicacion"]
            labelReferencia.text = tmpevento["referencia"]
            labelCalendario.text = tmpevento["calendario"]
            df.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
            let f = df.date(from: tmpevento["fecha"]!)
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            labelFecha.text = df.string(from: f!)
            labelTipo.text = dicT[tmpevento["tipo"]!]
        }
    }

    @IBAction func cancelar(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindEventoDet", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
