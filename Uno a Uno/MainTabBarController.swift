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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checaAutorizacionCal()
        //dicTojson()
    }
    
    func checaAutorizacionCal() {
        
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        switch (status) {
        case EKAuthorizationStatus.authorized:
            self.tabBar.items?[0].isEnabled = true
            self.selectedIndex = 0
            permiso = true
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied, EKAuthorizationStatus.notDetermined:
            self.eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
                if accessGranted == true {
                    self.tabBar.items?[0].isEnabled = true
                    self.selectedIndex = 0
                    permiso = true
                }
                else {
                    self.solicitarPermisoCal()
                    DispatchQueue.main.async(execute: {
                        self.tabBar.items?[0].isEnabled = false
                        self.selectedIndex = 1
                        permiso = false
                    })
                }
            })
        }
        
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

    func dicTojson() {
        
        let dict1 = ["mes": "ENE 16", "llamadas": 13, "citas": 21] as [String : Any]
        let dict2 = ["mes": "FEB 16", "llamadas": 10, "citas": 23] as [String : Any]
        let dict = [dict1, dict2]
        let d = ["datos": dict]
        
        var file = "file.txt"
        let text = "some text"
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            print(dir)
            let path = dir.appendingPathComponent(file)
            do {
                try text.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {
            }
            do {
                let text2 = try String(contentsOf: path, encoding: String.Encoding.utf8)
                print(text2)
            }
            catch {
            }
        }
        
        do {
            let theJSONData = try JSONSerialization.data(withJSONObject: d, options:.prettyPrinted)
            let theJSONText = NSString(data: theJSONData, encoding: String.Encoding.ascii.rawValue)
            print("JSON string = \(theJSONText!)")
        }
        catch {
            
        }
        
        
        let bundlePath = Bundle.main.path(forResource: "Web/reporte", ofType: ".html")
        print(bundlePath ?? "x", "\n")
        
        if let destPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        
            file = "reporte.html"
            let path = destPath.appendingPathComponent(file)
            print(path)
            let fullDestPathString = String(describing: path)
            print(fullDestPathString)
            let fileManager = FileManager.default
            print(fileManager.fileExists(atPath: bundlePath!))
            
            do {
                try fileManager.copyItem(atPath: bundlePath!, toPath: fullDestPathString)
            }
            catch {
                print("\n")
                print(error)
            }
        }
        
    }
    
}
