//
//  LoginViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 26/09/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var imgUaU: UIImageView!
    @IBOutlet weak var textCorreo: UITextField!
    @IBOutlet weak var textContrasenia: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textCorreo.delegate = self
        textContrasenia.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func accederSistema(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "ATENCION".lang, message: "INF_INC".lang, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alertController.addAction(okAction)
        
        var login: String = ""
        let url = URL(string: "http://ec2-52-52-32-4.us-west-1.compute.amazonaws.com/login.php")
        let postString: String = "correo="+self.textCorreo.text!+"&password="+self.textContrasenia.text!
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error
            in guard error == nil && data != nil
            else {
                print("error=\(error)")
                mostrarAviso(titulo: "ATENCION".lang, mensaje: "NO_CON".lang, viewController: self)
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("\(httpStatus.statusCode) = \(response)")
            }
            DispatchQueue.main.async {
                login = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                if login == "Login" {
                    self.performSegue(withIdentifier: "seguePrincipal", sender: self)
                }
                else if login == "IncUser" || login == "IncPass" {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        })
        task.resume()
        
    }
    
    @IBAction func mostrarRestablecer(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Restablecer contraseña", message: "Ingrese su correo electrónico para enviarle su nueva contraseña.", preferredStyle: UIAlertControllerStyle.alert)

        let saveAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) -> Void in
            
            var contra: String = ""
            let url = URL(string: "http://ec2-52-52-32-4.us-west-1.compute.amazonaws.com/contra.php")
            let postString: String = "correo="+alertController.textFields![0].text!
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.httpBody = postString.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error
                in guard error == nil && data != nil
                else {
                    mostrarAviso(titulo: "ATENCION".lang, mensaje: "NO_CON".lang, viewController: self)
                    print("error=\(error)")
                    return
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("\(httpStatus.statusCode) = \(response)")
                }
                DispatchQueue.main.async {
                    contra = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                }
            })
            task.resume()
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Correo electrónico"
            textField.keyboardType = UIKeyboardType.emailAddress
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
 
    @IBAction func registrarUsuario(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueRegistro", sender: self)
    }
    
    @IBAction func unwindRegistro(sender: UIStoryboardSegue) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

