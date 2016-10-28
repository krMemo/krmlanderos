//
//  RegistroViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 28/09/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class RegistroViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textNombre: UITextField!
    @IBOutlet weak var textApaterno: UITextField!
    @IBOutlet weak var textAmaterno: UITextField!
    @IBOutlet weak var textCorreo: UITextField!
    @IBOutlet weak var textRCorreo: UITextField!
    @IBOutlet weak var textContrasenia: UITextField!
    
    @IBAction func CambiarMayusculas(_ sender: UITextField) {
        textNombre.text = textNombre.text!.uppercased()
        textApaterno.text = textApaterno.text!.uppercased()
        textAmaterno.text = textAmaterno.text!.uppercased()
    }
    
    @IBAction func ConfirmarCorreo(_ sender: UITextField) {
        if textCorreo.text != textRCorreo.text {
            textRCorreo.text = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textNombre.delegate = self
        textApaterno.delegate = self
        textAmaterno.delegate = self
        textCorreo.delegate = self
        textRCorreo.delegate = self
        textContrasenia.delegate = self
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
    
    @IBAction func registrarUsuario(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Atención", message: "Registro exitoso.", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in NSLog("OK Pressed")
            self.performSegue(withIdentifier: "seguePrincipal", sender: self)
        }
        alertController.addAction(okAction)
        
        var registro: String = ""
        let url = URL(string: "http://ec2-52-52-32-4.us-west-1.compute.amazonaws.com/registro.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let postString = "nombre="+textNombre.text!+"&apaterno="+textApaterno.text!+"&amaterno="+textAmaterno.text!+"&correo="+textCorreo.text!+"&password="+self.textContrasenia.text!
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in guard error == nil && data != nil else {
                print("error=\(error)")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("\(httpStatus.statusCode) = \(response)")
            }
            DispatchQueue.main.async {
                registro = String(data: data!, encoding: String.Encoding.utf8)!
                if registro == "OkUser" {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        })
        task.resume()

    }

    @IBAction func cancelar(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindRegistro", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
