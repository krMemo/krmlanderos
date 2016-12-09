//
//  EventoViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 03/11/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit
import EventKit

class EventoViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    var idx: Int = 0
    var fecha: Date = Date()
    var cals: [EKCalendar]?
    var calendars: [EKCalendar] = []
    var evento: [String:String] = ["id":"", "persona":"", "tipo":"", "fecha":"", "evento":"", "notas":""]
    let eventStore = EKEventStore()
    var id: String = ""
    var tipo: String = ""
    
    @IBOutlet weak var pickerCalendario: UIPickerView!
    @IBOutlet weak var pickerTipo: UIPickerView!
    @IBOutlet weak var datepickerFecha: UIDatePicker!
    @IBOutlet weak var textEvento: UITextField!
    @IBOutlet weak var textPersona: UITextField!
    @IBOutlet weak var textNotas: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerCalendario.delegate = self
        pickerCalendario.dataSource = self
        pickerTipo.delegate = self
        pickerTipo.dataSource = self
        textEvento.delegate = self
        cals = eventStore.calendars(for: EKEntityType.event)
        for cal in cals! {
            if cal.allowsContentModifications {
                calendars.append(cal)
            }
        }
        datepickerFecha.date = fecha
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var numero: Int = 0
        if pickerView == pickerTipo {
            numero = 2
        }
        else if pickerView == pickerCalendario {
            numero = calendars.count
        }
        return numero
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var titulo: String = ""
        if pickerView == pickerTipo {
            titulo = row == 1 ? "Llamada" : "Cita"
        }
        else if pickerView == pickerCalendario {
            titulo = calendars[row].title
        }
        return titulo
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerTipo {
            tipo = row == 1 ? "Llamada" : "Cita"
        }
        else if pickerView == pickerCalendario {
            idx = row
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if textField.text != "" {
            textField.borderStyle = UITextBorderStyle.none
        }
        else {
            textField.borderStyle = UITextBorderStyle.roundedRect
        }
        return false
    }
    
    @IBAction func buscarPersona(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueBuscar", sender: self)
    }
    
    @IBAction func guardarEvento(_ sender: UIButton) {
        let newEvent = EKEvent(eventStore: eventStore)
        newEvent.calendar = calendars[idx]
        newEvent.title = textEvento.text!
        newEvent.startDate = datepickerFecha.date
        newEvent.endDate = datepickerFecha.date
        //evento["id"] =
        //print(newEvent.calendarItemIdentifier)
        print(newEvent.eventIdentifier)
        
        
        do {
            try eventStore.save(newEvent, span: .thisEvent)
        } catch {
            mostrarAviso(titulo: "ATENCION".lang, mensaje: "No se guardó el evento", viewController: self)
            print(error)
        }
    }

    @IBAction func unwindBuscar(sender: UIStoryboardSegue) {
        
    }
    
    @IBAction func cancelar(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindEvento", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
