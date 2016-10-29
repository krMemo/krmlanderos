//
//  MainTabBarController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 19/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit
import EventKit

class MainTabBarController: UITabBarController {

    let eventStore = EKEventStore()
    var calendars: [EKCalendar]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checaAutorizacionCal()
    }
    
    func checaAutorizacionCal() {
        
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        switch (status) {
        case EKAuthorizationStatus.authorized:
            self.tabBar.items?[0].isEnabled = true
            self.selectedIndex = 0
            cargarCalendarios()
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied, EKAuthorizationStatus.notDetermined:
            self.eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
                if accessGranted == true {
                    self.tabBar.items?[0].isEnabled = true
                    self.selectedIndex = 0
                    self.cargarCalendarios()
                }
                else {
                    self.solicitarPermisoCal()
                    DispatchQueue.main.async(execute: {
                        self.tabBar.items?[0].isEnabled = false
                        self.selectedIndex = 1
                    })
                }
            })
        }
        
    }

    func cargarCalendarios() {
        calendars = eventStore.calendars(for: EKEntityType.event)
        print(calendars?.description as Any)
    }
    
    func solicitarPermisoCal() {
        
        let alertController = UIAlertController(title: "Permiso", message: "La aplicacion necesita permiso para acceder a su calendario.", preferredStyle: UIAlertControllerStyle.alert)
        let saveAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        alertController.addAction(saveAction)
        self.present(alertController, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
