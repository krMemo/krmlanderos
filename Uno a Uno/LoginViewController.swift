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
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRecoverPass: UIButton!
    @IBOutlet weak var btnNewAccount: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textCorreo.delegate = self
        textContrasenia.delegate = self
        abrirDB()
        insertRegistro()
        selectRegistro()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let screenSize:CGFloat = self.view.bounds.height
        let middle:CGFloat = screenSize/2
        let uauSize:CGFloat = self.imgUaU.image!.size.height/2
        
        //Alignment
        self.imgUaU.center.y = screenSize/2
        self.btnNewAccount.center.y = screenSize-(screenSize/5)
        
        
        //Alphas
        self.textCorreo.alpha = 0
        self.textContrasenia.alpha = 0
        self.btnLogin.alpha = 0
        self.btnRecoverPass.alpha = 0
        self.btnNewAccount.alpha = 0
        
        UIView.animate(withDuration: 0.25, delay: 0.2, options: [.curveEaseOut], animations: {
            self.imgUaU.center.y -= (middle - uauSize - screenSize*0.05)
            self.textCorreo.alpha += 1
            self.textContrasenia.alpha += 1
            self.btnLogin.alpha += 1
            self.btnRecoverPass.alpha += 1
            self.btnNewAccount.alpha += 1
            
            }, completion: nil)
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
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in guard error == nil && data != nil else {
            print("error=\(error)")
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
    
    @IBAction func MostrarRestablecer(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Restablecer contraseña", message: "Ingrese su correo electrónico para enviarle su nueva contraseña.", preferredStyle: UIAlertControllerStyle.alert)
        let saveAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            var contra: String = ""
            let url = URL(string: "http://ec2-52-52-32-4.us-west-1.compute.amazonaws.com/contra.php")
            let postString: String = "correo="+alertController.textFields![0].text!
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.httpBody = postString.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in guard error == nil && data != nil else {
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
    
}

