//
//  CalendarioController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 05/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit
import EventKit

class CalendarioController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    var idx: Int = 0
    var animationFinished = true
    var cals: [EKCalendar]?
    var calendars: [EKCalendar] = []
    let eventStore = EKEventStore()
    
    @IBOutlet weak var labelMes: UILabel!
    @IBOutlet weak var calendarmenuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var datepickerEvento: UIDatePicker!
    @IBOutlet weak var pickerEvento: UIPickerView!
    @IBOutlet weak var textNombreEvento: UITextField!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calendarmenuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
    func presentationMode() -> CalendarMode {
        return CalendarMode.monthView
    }
    
    func firstWeekday() -> Weekday {
        return Weekday.sunday
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        textNombreEvento.delegate = self
        pickerEvento.delegate = self
        pickerEvento.dataSource = self
        calendarmenuView.menuViewDelegate = self
        calendarView.calendarDelegate = self
        labelMes.text = CVDate(date: Date()).globalDescription
        cals = eventStore.calendars(for: EKEntityType.event)
        for cal in cals! {
            if cal.allowsContentModifications {
                calendars.append(cal)
            }
        }
    }

    func presentedDateUpdated(_ date: CVDate) {
        if labelMes.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = labelMes.textColor
            updatedMonthLabel.font = labelMes.font
            updatedMonthLabel.textAlignment = .center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = labelMes.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.animationFinished = false
                self.labelMes.transform = CGAffineTransform(translationX: 0, y: -offset)
                self.labelMes.transform = CGAffineTransform(scaleX: 1, y: 0.3)
                self.labelMes.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransform.identity
                
            }) { _ in
                
                self.animationFinished = true
                self.labelMes.frame = updatedMonthLabel.frame
                self.labelMes.text = updatedMonthLabel.text
                self.labelMes.transform = CGAffineTransform.identity
                self.labelMes.alpha = 1
                updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: labelMes)
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
    
    @IBAction func guardarEvento(_ sender: UIButton) {
        let newEvent = EKEvent(eventStore: eventStore)
        newEvent.calendar = calendars[idx]
        newEvent.title = textNombreEvento.text!
        newEvent.startDate = datepickerEvento.date
        newEvent.endDate = datepickerEvento.date
        do {
            try eventStore.save(newEvent, span: .thisEvent)
        } catch {
            mostrarAviso(titulo: "ATENCION".lang, mensaje: "No se guardó el evento", viewController: self)
            print(error)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
