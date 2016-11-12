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
    var cals: [EKCalendar]?
    var calendars: [EKCalendar] = []
    let eventStore = EKEventStore()
    
    @IBOutlet weak var pickerEvento: UIPickerView!
    @IBOutlet weak var datepickerEvento: UIDatePicker!
    @IBOutlet weak var textEvento: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerEvento.delegate = self
        pickerEvento.dataSource = self
        textEvento.delegate = self
        cals = eventStore.calendars(for: EKEntityType.event)
        for cal in cals! {
            if cal.allowsContentModifications {
                calendars.append(cal)
            }
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return calendars.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return calendars[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        idx = row
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
    
    @IBAction func guardarEvento(_ sender: UIButton) {
        let newEvent = EKEvent(eventStore: eventStore)
        newEvent.calendar = calendars[idx]
        newEvent.title = textEvento.text!
        newEvent.startDate = datepickerEvento.date
        newEvent.endDate = datepickerEvento.date
        do {
            try eventStore.save(newEvent, span: .thisEvent)
        } catch {
            mostrarAviso(titulo: "ATENCION".lang, mensaje: "No se guardó el evento", viewController: self)
            print(error)
        }
    }
    
    @IBAction func cancelar(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindEvento", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
