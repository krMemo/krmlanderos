//
//  Functions.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 02/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

var permisoCalendario: Bool = false
var permisoContactos: Bool = false

extension String {
    var lang: String {
        return NSLocalizedString(self, comment: "")
    }
}

func mostrarAviso(titulo: String, mensaje: String, viewController: UIViewController) {
    let alertController = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.alert)
    let action = UIAlertAction(title: "OK".lang, style: UIAlertActionStyle.default)
    alertController.addAction(action)
    viewController.present(alertController, animated: true, completion: nil)
}

func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
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

func fechaAct() -> Date {
    let calendar = Calendar(identifier: .gregorian)
    let dateComponents = calendar.dateComponents([.day, .month, .year], from: Date())
    let date = calendar.date(from: dateComponents)!
    return date
}
