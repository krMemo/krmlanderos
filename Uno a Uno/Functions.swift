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

class CustomCell: UITableViewCell {
    
    var lblNombre: UILabel!
    var lblReferencia: UILabel!
    var lblEstatus: UILabel!
    
    init(frame: CGRect) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        lblNombre = UILabel(frame: CGRect(x: 15, y: 10, width: 200, height: 18))
        lblNombre.textColor = .black
        lblNombre.font = .systemFont(ofSize: 15, weight: UIFontWeightRegular)
        addSubview(lblNombre)
        lblReferencia = UILabel(frame: CGRect(x: 15, y: 30, width: 200, height: 15))
        lblReferencia.textColor = .darkGray
        lblReferencia.font = .systemFont(ofSize: 12, weight: UIFontWeightRegular)
        addSubview(lblReferencia)
        lblEstatus = UILabel(frame: CGRect(x: 200, y: 15, width: 150, height: 18))
        lblEstatus.textColor = .black
        lblEstatus.font = .systemFont(ofSize: 15, weight: UIFontWeightRegular)
        lblEstatus.textAlignment = .right
        addSubview(lblEstatus)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class EventCell: UITableViewCell {
    
    var lblNombre: UILabel!
    var lblReferencia: UILabel!
    var lblNotas: UILabel!
    var lblHora: UILabel!
    var imgCal: UIImageView!
    
    init(frame: CGRect) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        lblNombre = UILabel(frame: CGRect(x: 45, y: 10, width: 150, height: 18))
        lblNombre.textColor = .black
        lblNombre.font = .systemFont(ofSize: 15, weight: UIFontWeightRegular)
        addSubview(lblNombre)
        lblReferencia = UILabel(frame: CGRect(x: 230, y: 10, width: 100, height: 18))
        lblReferencia.textColor = .darkGray
        lblReferencia.font = .systemFont(ofSize: 12, weight: UIFontWeightRegular)
        lblReferencia.textAlignment = .right
        addSubview(lblReferencia)
        lblHora = UILabel(frame: CGRect(x: 45, y: 30, width: 200, height: 15))
        lblHora.textColor = .darkGray
        lblHora.font = .systemFont(ofSize: 12, weight: UIFontWeightRegular)
        addSubview(lblHora)
        lblNotas = UILabel(frame: CGRect(x: 85, y: 30, width: 250, height: 15))
        lblNotas.textColor = .black
        lblNotas.font = .systemFont(ofSize: 15, weight: UIFontWeightRegular)
        addSubview(lblNotas)
        imgCal = UIImageView()
        imgCal.contentMode = .scaleAspectFit
        imgCal.frame.size.width = 20
        imgCal.frame.size.height = 20
        imgCal.frame.origin.x = 15
        imgCal.frame.origin.y = 12
        addSubview(imgCal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

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

func removeChars(_ str: String) -> String {
    var ret: String = str
    ret = ret.replacingOccurrences(of: "!", with: "")
    ret = ret.replacingOccurrences(of: "$", with: "")
    ret = ret.replacingOccurrences(of: "_", with: "")
    ret = ret.replacingOccurrences(of: "<", with: "")
    ret = ret.replacingOccurrences(of: ">", with: "")
    return ret
}

func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

func dicTojson(archivo: String, _ dictionary: [[String:String]]) {
    let dict = ["datos": dictionary]
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options:.prettyPrinted)
        let jsonText = NSString(data: jsonData, encoding: String.Encoding.ascii.rawValue)!
        let json: String = "json = \(jsonText)"
        let docPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            try json.write(to: docPath.appendingPathComponent(archivo), atomically: false, encoding: String.Encoding.utf8)
        }
        catch {
            print("No se escribió la información")
        }
        do {
            let text = try String(contentsOf: docPath.appendingPathComponent(archivo), encoding: String.Encoding.utf8)
            print(text)
        }
        catch {
        }
    }
    catch {
        print("No se guardó la información")
    }
}
    
func writeFiles() {
    let files = ["repLlamadasCitas.html", "repClientesReferidos.html", "jquery.js", "highcharts.js", "touchSwipe.js", "transform.js", "styles.css"]
    let x = FileManager.default
    let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let bundlePath = Bundle.main.resourceURL!
    for file in files {
        do {
            try x.copyItem(at: bundlePath.appendingPathComponent("Web/" + file), to: documentPath.appendingPathComponent(file))
        }
        catch {
        }
    }
}

func fechaAct() -> Date {
    let calendar = Calendar(identifier: .gregorian)
    let dateComponents = calendar.dateComponents([.day, .month, .year], from: Date())
    let date = calendar.date(from: dateComponents)!
    return date
}

func imageColor(color: String) -> String {
    var img: String
    switch color {
    case "#1BADF8":
        img = "cblue"
    case "#A2845E":
        img = "cbrown"
    case "#63DA38":
        img = "cgreen"
    case "#FF9500":
        img = "corange"
    case "#CC73E1":
        img = "cpurple"
    case "#FF2968":
        img = "cred"
    case "#FFCC00":
        img = "cyellow"
    default:
        img = ""
    }
    return img
}

extension UIColor {
    var rgbComponents:(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        if getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (r,g,b,a)
        }
        return (0,0,0,0)
    }
    var hexRGBColor:String {
        return String(format: "#%02X%02X%02X", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255),Int(rgbComponents.blue * 255))
    }
    var hexRGBaColor:String {
        return String(format: "#%02X%02X%02X%02X", Int(rgbComponents.red * 255), Int(rgbComponents.green * 255),Int(rgbComponents.blue * 255),Int(rgbComponents.alpha * 255) )
    }
}
