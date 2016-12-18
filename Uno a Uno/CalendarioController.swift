//
//  CalendarioController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 05/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit
import EventKit

class CalendarioController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    var idx: Int = -1
    var eventId: String = ""
    var nuevo: Bool = true
    var fecha: Date = fechaAct()
    var animationFinished = true
    let eventStore = EKEventStore()
    var cals: [EKCalendar] = []
    var calendars: [EKCalendar] = []
    var events: [EKEvent] = []
    
    @IBOutlet weak var labelMes: UILabel!
    @IBOutlet weak var calendarmenuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var tableEventos: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        labelMes.text = CVDate(date: fecha).commonDescription
        calendarmenuView.menuViewDelegate = self
        calendarView.calendarDelegate = self
        tableEventos.delegate = self
        tableEventos.dataSource = self
        if permisoCalendario {
            cals = eventStore.calendars(for: EKEntityType.event)
            for cal in cals {
                if cal.allowsContentModifications {
                    calendars.append(cal)
                }
            }
        }
        let predicate = eventStore.predicateForEvents(withStart: fecha, end: fecha + (24*3600), calendars: calendars)
        events = eventStore.events(matching: predicate)
        tableEventos.reloadData()
    }

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
    
    func presentedDateUpdated(_ date: CVDate) {
        if labelMes.text != date.commonDescription && animationFinished {
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
        idx = -1
        fecha = date.convertedDate()!
        let predicate = eventStore.predicateForEvents(withStart: fecha, end: fecha + (24*3600), calendars: calendars)
        events = eventStore.events(matching: predicate)
        tableEventos.reloadData()
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
        let tmpfecha = dayView.date.convertedDate()!
        let predicate = eventStore.predicateForEvents(withStart: tmpfecha, end: tmpfecha + (24*3600), calendars: calendars)
        let tmpevents = eventStore.events(matching: predicate)
        if tmpevents.count > 0 {
            let calendar = Calendar.current
            let day = calendar.component(.day, from: tmpevents[0].startDate)
            if day == dayView.date.day {
                return true
            }
        }
        return false
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        let tmpfecha = dayView.date.convertedDate()!
        let predicate = eventStore.predicateForEvents(withStart: tmpfecha, end: tmpfecha + (24*3600), calendars: calendars)
        let tmpevents = eventStore.events(matching: predicate)
        if tmpevents.count == 1 {
            let uiColor1 = UIColor(cgColor: tmpevents[0].calendar.cgColor)
            return [uiColor1]
        }
        else if tmpevents.count == 2 {
            let uiColor1 = UIColor(cgColor: tmpevents[0].calendar.cgColor)
            let uiColor2 = UIColor(cgColor: tmpevents[1].calendar.cgColor)
            return [uiColor1, uiColor2]
        }
        else if tmpevents.count >= 3 {
            let uiColor1 = UIColor(cgColor: tmpevents[0].calendar.cgColor)
            let uiColor2 = UIColor(cgColor: tmpevents[1].calendar.cgColor)
            let uiColor3 = UIColor(cgColor: tmpevents[2].calendar.cgColor)
            return [uiColor1, uiColor2, uiColor3]
        }
        return []
    }
    
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 15
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = events[indexPath.row].title
        cell.detailTextLabel?.text = String(describing: events[indexPath.row].startDate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idx = indexPath.item
        if (events.count > indexPath.row) {
            eventId = events[idx].eventIdentifier
        }
    }
    
    @IBAction func irMesAtras(_ sender: UIButton) {
        calendarView.loadPreviousView()
    }
    
    @IBAction func irMesAdelante(_ sender: UIButton) {
        calendarView.loadNextView()
    }
    
    @IBAction func irHoy(_ sender: UIButton) {
        calendarView.toggleViewWithDate(Date())
    }
    
    @IBAction func añadirEvento(_ sender: UIButton) {
        nuevo = true
        self.performSegue(withIdentifier: "segueEvento", sender: self)
    }
    
    @IBAction func editarEvento(_ sender: UIButton) {
        nuevo = false
        if idx >= 0 {
            self.performSegue(withIdentifier: "segueEvento", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let eventoVC = segue.destination as! EventoViewController
        eventoVC.nuevo = nuevo
        eventoVC.fecha = fecha
        if idx >= 0 && nuevo == false {
            eventoVC.eventid = eventId
            eventoVC.evento["eventid"] = events[idx].eventIdentifier
            eventoVC.evento["fecha"] = String(describing: events[idx].startDate)
            eventoVC.evento["evento"] = events[idx].title
            eventoVC.evento["calendario"] = events[idx].calendar.title
        }
    }
    
    @IBAction func unwindEvento(sender: UIStoryboardSegue) {
        idx = -1
        let tmpfecha: Date = fechaAct()
        let predicate = eventStore.predicateForEvents(withStart: tmpfecha, end: tmpfecha + (24*3600), calendars: calendars)
        events = eventStore.events(matching: predicate)
        tableEventos.reloadData()
        calendarView.toggleViewWithDate(tmpfecha)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
