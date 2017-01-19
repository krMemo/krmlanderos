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
    @IBOutlet weak var segCliRef: UISegmentedControl!
    @IBOutlet weak var switchTodos: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableContactos.delegate = self
        tableContactos.dataSource = self
        let contactStore = CNContactStore()
        var allContainers: [CNContainer] = []
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactPostalAddressesKey] as [Any]
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
        results.sort{$0.givenName < $1.givenName}
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
            contacto["cliente"] = ""
            idx = 0
            for phone in contact.phoneNumbers {
                telefono["identifier"] = contact.identifier
                telefono["idx"] = String(idx)
                telefono["telefono"] = phone.value.stringValue
                telefono["tipo"] = removeChars(phone.label ?? "phone")
                telefono["principal"] = idx == 0 ? "1" : "0"
                telefonos.append(telefono)
                idx += 1
            }
            idx = 0
            for mail in contact.emailAddresses {
                correo["identifier"] = contact.identifier
                correo["idx"] = String(idx)
                correo["correo"] = String(mail.value)
                correo["tipo"] = removeChars(mail.label ?? "email")
                correo["principal"] = idx == 0 ? "1" : "0"
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
        for tel in telefonos {
            if tel["identifier"] == contactos[indexPath.row]["identifier"]! {
                cell.detailTextLabel?.text = tel["telefono"]
            }
        }
        cell.accessoryType = contactos[indexPath.row]["importar"] == "1" ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contactos[indexPath.row]["importar"] = contactos[indexPath.row]["importar"] == "1" ? "0" : "1"
        tableContactos.reloadData()
    }
    
    func importar(clientes: Bool) {
        var id: String = ""
        for var xcontact in contactos {
            if xcontact["importar"] == "1" {
                xcontact["cliente"] = clientes ? "1" : "0"
                xcontact["estatus"] = clientes ? "CO" : "PE"
                id = selectMaxId(tabla: "personas")
                xcontact["id"] = id
                executePersonas("INSERT", persona: xcontact)
                var xphones: [[String:String]] = []
                for var xphone in telefonos {
                    if xphone["identifier"] == xcontact["identifier"] {
                        xphone["id"] = id
                        xphones.append(xphone)
                    }
                }
                update(id, telefonos: xphones)
                var xmails: [[String:String]] = []
                for var xmail in correos {
                    if xmail["identifier"] == xcontact["identifier"] {
                        xmail["id"] = id
                        xmails.append(xmail)
                    }
                }
                update(id, correos: xmails)
                if clientes {
                    addHistorial(id, estatus: "CLI")
                }
            }
        }
    }
    
    @IBAction func seleccionarTodos(_ sender: UISwitch) {
        for x in 0 ..< contactos.count {
            contactos[x]["importar"] = switchTodos.isOn ? "1" : "0"
        }
        tableContactos.reloadData()
    }
    
    @IBAction func importar(_ sender: UIButton) {
        importar(clientes: segCliRef.selectedSegmentIndex == 0 ? true : false)
        mostrarAviso(titulo: "", mensaje: "Los contactos se importaron exitosamente", viewController: self)
        self.performSegue(withIdentifier: "unwindImportar", sender: self)
    }

    @IBAction func regresar(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindImportar", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
