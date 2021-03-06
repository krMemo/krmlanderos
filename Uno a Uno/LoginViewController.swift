//
//  LoginViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 26/09/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit
import EventKit
import Contacts

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var imgUaU: UIImageView!
    @IBOutlet weak var textCorreo: UITextField!
    @IBOutlet weak var textContrasenia: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRecoverPass: UIButton!
    @IBOutlet weak var btnNewAccount: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textCorreo.delegate = self
        textContrasenia.delegate = self
        crearDB()
        autorizacionCalendario()
        autorizacionContactos()
    }
    
    func autorizacionCalendario() {
        DispatchQueue.main.async(execute: {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        switch status {
            case .authorized:
                permisoCalendario = true
            case .restricted, .denied, .notDetermined:
                let eventStore = EKEventStore()
                eventStore.requestAccess(to: EKEntityType.event, completion: {
                    (accessGranted: Bool, error: Error?) in
                    if accessGranted {
                        permisoCalendario = true
                    }
                    else {
                        permisoCalendario = false
                    }
                })
            }
        })
    }
    
    func autorizacionContactos() {
        DispatchQueue.main.async(execute: {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        switch authorizationStatus {
            case .authorized:
                permisoContactos = true
            case .restricted, .denied, .notDetermined:
                let contactStore = CNContactStore()
                contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: {
                    (access: Bool, error: Error?) -> Void in
                    if access {
                        permisoContactos = true
                    }
                    else {
                        permisoContactos = true
                    }
                })
            }
                
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let screenSize:CGFloat = self.view.bounds.height
        
        //Alignment
        self.imgUaU.center.y = screenSize/2
        self.btnNewAccount.center.y = screenSize-(screenSize/5)
        
        
        //Alphas
        self.textCorreo.alpha = 0
        self.textContrasenia.alpha = 0
        self.btnLogin.alpha = 0
        self.btnRecoverPass.alpha = 0
        self.btnNewAccount.alpha = 0
        
        //Animation
        UIView.animate(withDuration: 0.5, delay: 0.5, options: [.curveEaseOut], animations: {
            self.imgUaU.center.y -= screenSize/4
            self.textCorreo.alpha += 1
            self.textContrasenia.alpha += 1
            self.btnLogin.alpha += 1
            self.btnRecoverPass.alpha += 1
            self.btnNewAccount.alpha += 1
        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        let nextTage=textField.tag+1;
        let nextResponder=textField.superview?.viewWithTag(nextTage) as UIResponder!
        if (nextResponder != nil) {
            nextResponder?.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    @IBAction func accederSistema(_ sender: UIButton) {
        //valid mail & pass field
        self.performSegue(withIdentifier: "seguePrincipal", sender: self)
        if !isValidEmail(testStr: self.textCorreo.text!) {
            mostrarAviso(titulo: "ATENCION".lang, mensaje: "INVALID_MAIL".lang, viewController: self)
        } else if (self.textContrasenia.text!.isEmpty) {
            mostrarAviso(titulo: "ATENCION".lang, mensaje: "EMPTY_FIELD".lang, viewController: self)
        }
        else {
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
    }
    
    @IBAction func mostrarRestablecer(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "RECOVERY_PASS".lang, message: "RECOVERY_PASS_DESC".lang, preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "SEND".lang, style: UIAlertActionStyle.default, handler: {
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
                    print(contra)
                }
            })
            task.resume()
            
        })
        
        let cancelAction = UIAlertAction(title: "CANCEL".lang, style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "E_MAIL".lang
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
    
    @IBAction func unwindConfiguracion(sender: UIStoryboardSegue) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

