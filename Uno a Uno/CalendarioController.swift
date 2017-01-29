//
//  CalendarioController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 05/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit
import EventKit

class CalendarioController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, CVCalendarViewDelegate, CVCalendarMenuViewDelegate, CVCalendarViewAppearanceDelegate {
    
    var idx: Int = -1
    var eventId: String = ""
    var nuevo: Bool = true
    var fecha: Date = fechaAct()
    var animationFinished = true
    let eventStore = EKEventStore()
    var cals: [EKCalendar] = []
    var calendars: [EKCalendar] = []
    var events: [EKEvent] = []
    var eventos: [[String:String]] = []
    var evento: [String:String] = [:]
    
    @IBOutlet weak var datepickerFecha: UIDatePicker!
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
        eventos = []
        for event in events {
            evento = selectEvento(event.eventIdentifier)
            eventos.append(evento)
        }
        tableEventos.reloadData()
        datepickerFecha.addTarget(self, action: #selector(changeValue), for: UIControlEvents.valueChanged)
    }
    
    func changeValue() {
        calendarView.toggleViewWithDate(datepickerFecha.date)
    }

    override func viewWillAppear(_ animated: Bool) {
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
        datepickerFecha.date = fecha
        let predicate = eventStore.predicateForEvents(withStart: fecha, end: fecha + (24*3600), calendars: calendars)
        events = eventStore.events(matching: predicate)
        eventos = []
        for event in events {
            evento = selectEvento(event.eventIdentifier)
            eventos.append(evento)
        }
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
    
    func dotMarker(moveOffsetOnDayView dayView: DayView) -> CGFloat {
        return 15
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
        var calendarColor: [UIColor] = []
        let tmpfecha = dayView.date.convertedDate()!
        let predicate = eventStore.predicateForEvents(withStart: tmpfecha, end: tmpfecha + (24*3600), calendars: calendars)
        let tmpevents = eventStore.events(matching: predicate)
        if tmpevents.count >= 1 {
            calendarColor.append(UIColor.init(red: 0/255, green: 127/255, blue: 255/255, alpha: 1))
        }
        return calendarColor
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: DayView) -> Bool {
        return false
    }
    
    func topMarker(shouldDisplayOnDayView dayView: DayView) -> Bool {
        return true
    }
    
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 15
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        let cell = EventCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
        if eventos[indexPath.row]["id"] == "" {
            cell.lblNombre.text = events[indexPath.row].title
            cell.lblReferencia.text = ""
            cell.lblNotas.text = events[indexPath.row].notes
            df.dateFormat = "h:mm a."
            cell.lblHora.text = df.string(from: events[indexPath.row].startDate)
        }
        else {
            cell.lblNombre.text = eventos[indexPath.row]["evento"]!
            cell.lblReferencia.text = eventos[indexPath.row]["referencia"]!
            cell.lblNotas.text = eventos[indexPath.row]["notas"]!
            let f = df.date(from: eventos[indexPath.row]["fecha"]!)
            df.dateFormat = "h:mm a."
            cell.lblHora.text = df.string(from: f!)
            let d: Int = Int(eventos[indexPath.row]["duracion"]!)!
            cell.lblHoraMas.text = df.string(from: f!+TimeInterval(d))
        }
        if events.count > indexPath.row {
            let cal = events[indexPath.row].calendar
            let line = UIView(frame: CGRect(x: 70, y: 10, width: 2, height: 35))
            line.backgroundColor = UIColor(cgColor: cal.cgColor)
            cell.addSubview(line)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        cell.addGestureRecognizer(tap)
        
        return cell
    }
    
    func doubleTapped() {
        performSegue(withIdentifier: "segueEventoDet", sender: self)
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
        if segue.identifier == "segueEvento" {
            let eventoVC = segue.destination as! EventoViewController
            eventoVC.nuevo = nuevo
            eventoVC.fecha = fecha
            if idx >= 0 && nuevo == false {
                eventoVC.eventid = eventId
            }
        }
        else if segue.identifier == "segueEventoDet" {
            let eventodVC = segue.destination as! EventoDetViewController
            if idx >= 0 {
                eventodVC.id = eventId
            }
        }
    }
    
    @IBAction func unwindEvento(sender: UIStoryboardSegue) {
        idx = -1
        let tmpfecha: Date = fechaAct()
        let predicate = eventStore.predicateForEvents(withStart: tmpfecha, end: tmpfecha + (24*3600), calendars: calendars)
        events = eventStore.events(matching: predicate)
        eventos = []
        for event in events {
            evento = selectEvento(event.eventIdentifier)
            eventos.append(evento)
        }
        tableEventos.reloadData()
        calendarView.contentController.refreshPresentedMonth()
    }
    
    @IBAction func unwindEventoDet(sender: UIStoryboardSegue) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
