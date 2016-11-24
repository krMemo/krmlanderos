//
//  CalendarioController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 05/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit
import EventKit

class CalendarioController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    var animationFinished = true
    let eventStore = EKEventStore()
    var cals: [EKCalendar] = []
    var calendars: [EKCalendar] = []
    var events: [EKEvent] = []
    
    @IBOutlet weak var labelMes: UILabel!
    @IBOutlet weak var calendarmenuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var labelCalendario: UILabel!
    @IBOutlet weak var pickerEvento: UIPickerView!

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
        calendarmenuView.menuViewDelegate = self
        calendarView.calendarDelegate = self
        pickerEvento.delegate = self
        labelMes.text = CVDate(date: Date()).commonDescription
        cals = eventStore.calendars(for: EKEntityType.event)
        for cal in cals {
            if cal.allowsContentModifications {
                calendars.append(cal)
            }
        }
        let inicio = Date()
        let fin = Date(timeIntervalSinceNow: +24*3600)
        let predicate = eventStore.predicateForEvents(withStart: inicio, end: fin, calendars: calendars)
        events = eventStore.events(matching: predicate)
        print(events)
    }

    func presentedDateUpdated(_ date: CVDate) {
        if labelMes.text != date.commonDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.font = labelMes.font
            updatedMonthLabel.textAlignment = .center
            updatedMonthLabel.text = date.commonDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.center = labelMes.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0)
            
            UIView.animate(withDuration: 0.5, delay: 0.1, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.animationFinished = false
                self.labelMes.transform = CGAffineTransform(translationX: 0, y: -offset)
                self.labelMes.transform = CGAffineTransform(scaleX: 1, y: 0.01)
                self.labelMes.alpha = 0
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransform.identity
            })
            { _ in
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
    
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        let inicio = dayView.date.convertedDate()!
        let fin = dayView.date.convertedDate()! + (24*3600)
        let predicate = eventStore.predicateForEvents(withStart: inicio, end: fin, calendars: calendars)
        events = eventStore.events(matching: predicate)
        pickerEvento.reloadAllComponents()
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
    
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        let inicio = dayView.date.convertedDate()!
        let fin = dayView.date.convertedDate()! + (24*3600)
        let predicate = eventStore.predicateForEvents(withStart: inicio, end: fin, calendars: calendars)
        events = eventStore.events(matching: predicate)
        if events.count > 0 {
            let calendar = Calendar.current
            let day = calendar.component(.day, from: events[0].startDate)
            if day == dayView.date.day {
                return true
            }
        }
        return false
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        let inicio = dayView.date.convertedDate()!
        let fin = dayView.date.convertedDate()! + (24*3600)
        let predicate = eventStore.predicateForEvents(withStart: inicio, end: fin, calendars: calendars)
        events = eventStore.events(matching: predicate)
        if events.count == 1 {
            let uiColor1 = UIColor(cgColor: events[0].calendar.cgColor)
            return [uiColor1]
        }
        else if events.count == 2 {
            let uiColor1 = UIColor(cgColor: events[0].calendar.cgColor)
            let uiColor2 = UIColor(cgColor: events[1].calendar.cgColor)
            return [uiColor1, uiColor2]
        }
        else if events.count >= 3 {
            let uiColor1 = UIColor(cgColor: events[0].calendar.cgColor)
            let uiColor2 = UIColor(cgColor: events[1].calendar.cgColor)
            let uiColor3 = UIColor(cgColor: events[2].calendar.cgColor)
            return [uiColor1, uiColor2, uiColor3]
        }
        return []
    }
    
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 15
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return events.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return events[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        labelCalendario.text = events[row].calendar.title
    }
    
    @IBAction func irHoy(_ sender: UIButton) {
        calendarView.toggleViewWithDate(Date())
    }
    
    @IBAction func añadirEvento(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueEvento", sender: self)
    }
    
    @IBAction func unwindEvento(sender: UIStoryboardSegue) {
        pickerEvento.reloadAllComponents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
