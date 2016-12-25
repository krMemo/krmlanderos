//
//  ConfiguracionViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 14/12/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit
import Contacts

class ConfiguracionViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func importarContactos(_ sender: UIButton) {
        let contactStore = CNContactStore()
        var allContainers: [CNContainer] = []
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactPostalAddressesKey] as [Any]
        do {
            allContainers = try contactStore.containers(matching: nil)
        }
        catch {
            print("Error fetching containers")
        }
        var results: [CNContact] = []
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            }
            catch {
                print("Error fetching results for container")
            }
        }
        for contact in results {
            var idx: Int
            var contacto: [String:String] = ["id":"", "nombre":"", "apaterno":"", "amaterno":"", "direccion":"", "notas":"", "estatus":"", "cliente":"", "referencia":""]
            var telefonos: [[String:String]] = []
            var telefono: [String:String] = ["id":"", "idx":"", "principal":"", "telefono":"", "tipo":""]
            var correos: [[String:String]] = []
            var correo: [String:String] = ["id":"", "idx":"", "principal":"", "correo":"", "tipo":""]
            contacto["id"] = selectMaxId(tabla: "personas")
            contacto["nombre"] = contact.givenName
            contacto["apaterno"] = contact.familyName
            contacto["estatus"] = ""
            contacto["cliente"] = "0"
            executePersonas(accion: "INSERT", persona: contacto)
            idx = 0
            for phone in contact.phoneNumbers {
                telefono["id"] = contacto["id"]!
                telefono["idx"] = String(idx)
                print(String(idx))
                telefono["telefono"] = phone.value.stringValue
                telefono["tipo"] = phone.label!
                telefonos.append(telefono)
                idx += 1
            }
            update(telefonos: telefonos, id: contacto["id"]!)
            idx = 0
            for mail in contact.emailAddresses {
                correo["id"] = contacto["id"]!
                correo["idx"] = String(idx)
                correo["correo"] = String(mail.value)
                correo["tipo"] = mail.label
                correos.append(correo)
                idx += 1
            }
            update(correos: correos, id: correo["id"]!)
            idx = 0
            /*for postal in contact.postalAddresses {
                print(postal.value.street + " " + postal.value.city)
                
            }*/
        }
    }

    @IBAction func cerrarSesion(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindConfiguracion", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
