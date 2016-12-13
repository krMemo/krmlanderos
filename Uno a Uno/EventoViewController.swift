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
    var nuevo: Bool = true
    var fecha: Date = Date()
    var cals: [EKCalendar]?
    var calendars: [EKCalendar] = []
    var evento: [String:String] = ["id":"", "persona":"", "eventid":"", "calendario":"", "tipo":"", "fecha":"", "evento":"", "notas":""]
    let eventStore = EKEventStore()
    var eventid: String = ""
    var id: String = ""
    var tipo: String = ""
    var persona: String = ""
    
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
        datepickerFecha.setDate(fecha, animated: true)
        if !nuevo {
            let tmpevento = selectEvento(id: eventid)
            if tmpevento["id"] == "" {
                textEvento.text = evento["evento"]
                var i: Int = 0
                for cal in calendars {
                    if cal.title == evento["calendario"] {
                        pickerCalendario.selectRow(i, inComponent: 0, animated: true)
                    }
                    i += 1
                }
            }
            else {
                id = tmpevento["id"]!
                textEvento.text = tmpevento["evento"]
                textPersona.text = tmpevento["persona"]
                textNotas.text = tmpevento["notas"]
                pickerTipo.selectRow(tmpevento["tipo"] == "Llamada" ? 1 : 0, inComponent: 0, animated: true)
                var i: Int = 0
                for cal in calendars {
                    if cal.title == tmpevento["calendario"] {
                        pickerCalendario.selectRow(i, inComponent: 0, animated: true)
                    }
                    i += 1
                }
            }
        }
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
        var event = EKEvent(eventStore: eventStore)
        evento["persona"] = persona
        evento["tipo"] = tipo
        evento["calendario"] = calendars[idx].title
        evento["fecha"] = datepickerFecha.date.description
        evento["evento"] = textEvento.text
        evento["notas"] = textNotas.text
        print(evento)
        if nuevo {
            event.calendar = calendars[idx]
            event.title = textEvento.text!
            event.startDate = datepickerFecha.date
            event.endDate = datepickerFecha.date
            evento["eventid"] = event.eventIdentifier
            if id == "" {
                id = selectMaxId(tabla: "eventos")
                evento["id"] = id
                print("INSERT \(evento)")
                executeEventos(accion: "INSERT", evento: evento)
            }
            do {
                try eventStore.save(event, span: .thisEvent)
                mostrarAviso(titulo: "ATENCION".lang, mensaje: "Se guardó el evento exitosamente", viewController: self)
            }
            catch {
                mostrarAviso(titulo: "ATENCION".lang, mensaje: "No se guardó el evento", viewController: self)
                print(error)
            }
        }
        else {
            event = eventStore.event(withIdentifier: eventid)!
            event.calendar = calendars[idx]
            event.title = textEvento.text!
            event.startDate = datepickerFecha.date
            event.endDate = datepickerFecha.date
            if id == "" {
                id = selectMaxId(tabla: "eventos")
                evento["id"] = id
                print("INSERT \(evento)")
                executeEventos(accion: "INSERT", evento: evento)
            }
            else {
                print("UPDATE \(evento)")
                executeEventos(accion: "UPDATE", evento: evento)
            }
            do {
                try eventStore.save(event, span: .thisEvent)
                mostrarAviso(titulo: "ATENCION".lang, mensaje: "Se guardó el evento exitosamente", viewController: self)
            }
            catch {
                mostrarAviso(titulo: "ATENCION".lang, mensaje: "No se guardó el evento", viewController: self)
                print(error)
            }
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
