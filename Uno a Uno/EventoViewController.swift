//
//  EventoViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 03/11/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit
import EventKit

class EventoViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    var kb: Bool = false
    var idxTipo: Int = 0
    var idxDur: Int = 0
    var idxCal: Int = 0
    var nuevo: Bool = true
    var fecha: Date = Date()
    var cals: [EKCalendar]?
    var calendars: [EKCalendar] = []
    var evento: [String:String] = ["id":"", "eventid":"", "persona":"", "referencia":"", "correo":"", "ubicacion":"", "notas":"", "calendario":"", "tipo":"", "fecha":"", "duracion":"", "alarma":""]
    let eventStore = EKEventStore()
    var eventid: String = ""
    var id: String = ""
    var idpersona: String = ""
    let dicDuracion: [Int:String] = [0:"Minutos", 1:"Horas", 2:"Días"]
    let dicD: [String:String] = ["Minutos":"M", "Horas":"H", "Días":"D"]
    let dicTipo: [Int:String] = [0:"Llamada", 1:"Cita", 2:"Seguimiento", 3:"Tarea", 4:"Confirmación", 5:"Cumpleaños"]
    let dicT: [String:String] = ["Llamada":"LL", "Cita":"CT", "Seguimiento":"SE", "Tarea":"TA", "Confirmación":"CO", "Cumpleaños":"CU"]
    
    @IBOutlet weak var pickerCalendario: UIPickerView!
    @IBOutlet weak var pickerTipo: UIPickerView!
    @IBOutlet weak var pickerMHD: UIPickerView!
    @IBOutlet weak var datepickerFecha: UIDatePicker!
    @IBOutlet weak var datepickerAlarma: UIDatePicker!
    @IBOutlet weak var textPersona: UITextField!
    @IBOutlet weak var textCorreo: UITextField!
    @IBOutlet weak var textUbicacion: UITextField!
    @IBOutlet weak var textNotas: UITextView!
    @IBOutlet weak var textDuracion: UITextField!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var labelReferencia: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scroll.contentSize = CGSize(width: self.view.frame.size.width, height: 900)
        pickerCalendario.delegate = self
        pickerCalendario.dataSource = self
        pickerTipo.delegate = self
        pickerTipo.dataSource = self
        pickerMHD.delegate = self
        pickerMHD.dataSource = self
        textPersona.delegate = self
        textCorreo.delegate = self
        textUbicacion.delegate = self
        textNotas.delegate = self
        textDuracion.delegate = self
        cals = eventStore.calendars(for: EKEntityType.event)
        for cal in cals! {
            if cal.allowsContentModifications {
                calendars.append(cal)
            }
        }
        if !nuevo {
            cargaDatos()
        }
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [
            UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(kbCancelar)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Aceptar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(kbAceptar))
        ]
        textNotas.inputAccessoryView = toolBar
    }
    
    func carga(calendario: String, tipo: String) {
        var i: Int = 0
        for cal in calendars {
            if cal.title == calendario {
                pickerCalendario.selectRow(i, inComponent: 0, animated: true)
            }
            i += 1
        }
        if tipo != "" {
            for tipos in dicTipo {
                if dicT[tipos.value] == tipo {
                    pickerTipo.selectRow(tipos.key, inComponent: 0, animated: true)
                }
            }
        }
    }
    
    func cargaDatos() {
        print(eventid)
        let tmpevento = selectEvento(eventid)
        print(tmpevento)
        if tmpevento["id"] == "" {
            let event = eventStore.event(withIdentifier: eventid)
            textPersona.text = event?.title
            textUbicacion.text = event?.location
            textNotas.text = event?.notes
            datepickerFecha.setDate(fecha, animated: true)
            carga(calendario: (event?.calendar.title)!, tipo: "")
        }
        else {
            id = tmpevento["id"]!
            textPersona.text = tmpevento["evento"]
            textCorreo.text = tmpevento["correo"]
            textNotas.text = tmpevento["notas"]
            textUbicacion.text = tmpevento["ubicacion"]
            carga(calendario: tmpevento["calendario"]!, tipo: tmpevento["tipo"]!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
        if (nextResponder != nil) {
            nextResponder?.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func kbAceptar() {
        kb = false
        self.view.endEditing(true)
    }
    
    func kbCancelar() {
        kb = false
        textNotas.text = ""
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var numero: Int = 0
        if pickerView == pickerTipo {
            numero = dicTipo.count
        }
        if pickerView == pickerMHD {
            numero = dicDuracion.count
        }
        if pickerView == pickerCalendario {
            numero = calendars.count
        }
        return numero
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var titulo: String = ""
        if pickerView == pickerTipo {
            titulo = dicTipo[row]!
        }
        if pickerView == pickerMHD {
            titulo = dicDuracion[row]!
        }
        if pickerView == pickerCalendario {
            titulo = calendars[row].title
        }
        return titulo
    }
    
    @IBAction func buscarPersona(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueBuscar", sender: self)
    }
    
    func validaInfo() -> Bool {
        if idpersona == "" {
            mostrarAviso(titulo: "Importante", mensaje: "Debe seleccionar una persona para el evento.", viewController: self)
            return false
        }
        return true
    }
    
    @IBAction func guardarEvento(_ sender: UIButton) {
        if validaInfo() {
            var event = eventStore.event(withIdentifier: eventid)
            if event == nil {
                event = EKEvent(eventStore: eventStore)
            }
            event!.calendar = calendars[pickerCalendario.selectedRow(inComponent: 0)]
            event!.title = textPersona.text!
            event!.startDate = datepickerFecha.date
            event!.endDate = datepickerFecha.date + TimeInterval(getSeg())
            event!.addAlarm(EKAlarm.init(absoluteDate: datepickerAlarma.date))
            do {
                try eventStore.save((event)!, span: .thisEvent)
                mostrarAviso(titulo: "ATENCION".lang, mensaje: "Se guardó el evento exitosamente", viewController: self)
            }
            catch {
                mostrarAviso(titulo: "ATENCION".lang, mensaje: "No se guardó el evento", viewController: self)
            }
            print(event!.eventIdentifier as Any)
            evento["eventid"] = event?.eventIdentifier
            evento["persona"] = idpersona
            evento["tipo"] = dicT[dicTipo[pickerTipo.selectedRow(inComponent: 0)]!]
            evento["calendario"] = calendars[pickerCalendario.selectedRow(inComponent: 0)].title
            evento["duracion"] = String(getSeg())
            evento["fecha"] = datepickerFecha.date.description
            evento["evento"] = textPersona.text
            evento["correo"] = textCorreo.text
            evento["ubicacion"] = textUbicacion.text
            evento["notas"] = textNotas.text
            if id == "" {
                evento["id"] = selectMaxId(tabla: "eventos")
            }
            if nuevo {
                print("INSERT \(evento)")
                executeEventos(accion: "INSERT", evento: evento)
            }
            else {
                if id == "" {
                    print("INSERT \(evento)")
                    executeEventos(accion: "INSERT", evento: evento)
                }
                else {
                    print("UPDATE \(evento)")
                    executeEventos(accion: "UPDATE", evento: evento)
                }
            }
            performSegue(withIdentifier: "unwindEvento", sender: self)
        }
    }

    func getSeg() -> Int {
        var segundos: Int = 0
        if pickerMHD.selectedRow(inComponent: 0) == 0 {
            segundos = Int(textDuracion.text!)! * 60
        }
        else if pickerMHD.selectedRow(inComponent: 0) == 1 {
            segundos = Int(textDuracion.text!)! * 60 * 60
        }
        else if pickerMHD.selectedRow(inComponent: 0) == 2 {
            segundos = Int(textDuracion.text!)! * 60 * 60 * 24
        }
        print(segundos)
        return segundos
    }
    
    @IBAction func unwindBuscar(sender: UIStoryboardSegue) {
        if idpersona != "" {
            let persona = selectPersona(idpersona)
            labelReferencia.text = "Referencia: " + persona["referencia"]!
            textCorreo.text = textCorreo.text == "" ? persona["correo"] : textCorreo.text
            textUbicacion.text = textUbicacion.text == "" ? persona["direccion"] : textUbicacion.text
        }
    }
    
    @IBAction func cancelar(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindEvento", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
