//
//  ClienteDetViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 28/12/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class ClienteDetViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var labelNombre: UILabel!
    @IBOutlet weak var labelReferencia: UILabel!
    @IBOutlet weak var labelTelefono: UILabel!
    @IBOutlet weak var labelCorreo: UILabel!
    @IBOutlet weak var labelDireccion: UILabel!
    @IBOutlet weak var pickerEstatus: UIPickerView!
    
    var id: String = ""
    var cliente: [String:String] = [:]
    let dicEstatus: [Int:String] = [0:"Pendiente", 1:"Llamada", 2:"Cita", 3:"Seguimiento", 4:"Contrato", 5:"No Interesado"]
    let dicE: [String:String] = ["Pendiente":"PE", "Llamada":"LL", "Cita":"CT", "Seguimiento":"SE", "Contrato":"CO", "No Interesado":"NI"]

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerEstatus.delegate = self
        pickerEstatus.dataSource = self
        cliente = selectPersona(id)
        print(selectHistorial(id))
        labelNombre.text = cliente["nombrec"]
        labelReferencia.text = cliente["referencia"]
        labelTelefono.text = cliente["telefono"]
        labelCorreo.text = cliente["correo"]
        labelDireccion.text = cliente["direccion"]
        
        for estatus in dicEstatus {
            if dicE[estatus.value] == cliente["estatus"] {
                pickerEstatus.selectRow(estatus.key, inComponent: 0, animated: true)
            }
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dicE.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dicEstatus[row]
    }
    
    @IBAction func guardarEstatus(_ sender: UIButton) {
        cliente["estatus"] = dicE[dicEstatus[pickerEstatus.selectedRow(inComponent: 0)]!]
        executePersonas("UPDATE", persona: cliente)
        addHistorial(id, estatus: dicE[dicEstatus[pickerEstatus.selectedRow(inComponent: 0)]!]!)
        mostrarAviso(titulo: "Aviso", mensaje: "Se cambió el estratus correctamente.", viewController: self)
    }
    
    @IBAction func regresar(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindClienteDet", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
