//
//  ImportarViewController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 28/12/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit
import Contacts

class ImportarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var contactos: [[String:String]] = []
    var telefonos: [[String:String]] = []
    var correos: [[String:String]] = []
    var todos: Bool = false
    
    @IBOutlet weak var tableContactos: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableContactos.delegate = self
        tableContactos.dataSource = self
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
            var contacto: [String:String] = ["identifier":"", "nombrec":"", "importar":"", "id":"", "nombre":"", "apaterno":"", "amaterno":"", "direccion":"", "notas":"", "estatus":"", "cliente":"", "referencia":""]
            var telefono: [String:String] = ["id":"", "idx":"", "principal":"", "telefono":"", "tipo":"", "identifier":""]
            var correo: [String:String] = ["id":"", "idx":"", "principal":"", "correo":"", "tipo":"", "identifier":""]
            contacto["identifier"] = contact.identifier
            contacto["nombrec"] = contact.givenName + " " + contact.familyName
            contacto["importar"] = "0"
            contacto["nombre"] = contact.givenName
            contacto["apaterno"] = contact.familyName
            contacto["estatus"] = ""
            contacto["cliente"] = "0"
            idx = 0
            for phone in contact.phoneNumbers {
                telefono["identifier"] = contact.identifier
                telefono["idx"] = String(idx)
                telefono["telefono"] = phone.value.stringValue
                telefono["tipo"] = phone.label
                telefonos.append(telefono)
                idx += 1
            }
            idx = 0
            for mail in contact.emailAddresses {
                correo["identifier"] = contact.identifier
                correo["idx"] = String(idx)
                correo["correo"] = String(mail.value)
                correo["tipo"] = mail.label
                correos.append(correo)
                idx += 1
            }
            contactos.append(contacto)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
            cell.textLabel?.text = contactos[indexPath.row]["nombrec"]!
            cell.accessoryType = contactos[indexPath.row]["importar"] == "1" ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contactos[indexPath.row]["importar"] = contactos[indexPath.row]["importar"] == "1" ? "0" : "1"
        tableContactos.reloadData()
    }
    
    @IBAction func selectTodos(_ sender: UIButton) {
        todos = todos ? false : true
        for x in 0 ..< contactos.count {
            contactos[x]["importar"] = todos ? "1" : "0"
        }
        tableContactos.reloadData()
    }
    
    @IBAction func importar(_ sender: UIButton) {
        var id: String = ""
        for var xcontact in contactos {
            if xcontact["importar"] == "1" {
            print(xcontact)
                id = selectMaxId(tabla: "personas")
                xcontact["id"] = id
                executePersonas(accion: "INSERT", persona: xcontact)
                var xphones: [[String:String]] = []
                for xphone in telefonos {
                    if xphone["identifier"] == xcontact["identifier"] {
                        xphones.append(xphone)
                    }
                }
                update(telefonos: xphones, id: id)
                var xmails: [[String:String]] = []
                for xmail in correos {
                    if xmail["identifier"] == xcontact["identifier"] {
                        xmails.append(xmail)
                    }
                }
                update(correos: xmails, id: id)
            }
        }
    }

    @IBAction func regresar(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindImportar", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
