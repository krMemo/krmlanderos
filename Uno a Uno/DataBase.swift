//
//  DataBase.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 13/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import Foundation

func getDB() -> FMDatabase {
    let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let docsDir: String = dirPaths[0]
    let databasePath = docsDir + "/UaU.db"
    return FMDatabase(path: databasePath as String)
}

func crearDB() {
    var sql_stmt: String
    let db = getDB()
    if db.open() {
        sql_stmt = "CREATE TABLE IF NOT EXISTS personas (id INTEGER PRIMARY KEY, nombre TEXT, apaterno TEXT, amaterno TEXT, direccion TEXT, notas TEXT, estatus TEXT, cliente INTEGER, referencia TEXT)"
        if !(db.executeStatements(sql_stmt)) {
            print("Error: \(db.lastErrorMessage())")
        }
        else {
            print("Tabla 'personas': OK")
        }
        sql_stmt = "CREATE TABLE IF NOT EXISTS telefonos (id INTEGER, idx INTEGER, principal INTEGER, telefono TEXT, tipo TEXT)"
        if !(db.executeStatements(sql_stmt)) {
            print("Error: \(db.lastErrorMessage())")
        }
        else {
            print("Tabla 'telefonos': OK")
        }
        sql_stmt = "CREATE TABLE IF NOT EXISTS correos (id INTEGER, idx INTEGER, principal INTEGER, correo TEXT, tipo TEXT)"
        if !(db.executeStatements(sql_stmt)) {
            print("Error: \(db.lastErrorMessage())")
        }
        else {
            print("Tabla 'correos': OK")
        }
        sql_stmt = "CREATE TABLE IF NOT EXISTS eventos (id INTEGER PRIMARY KEY, persona INTEGER, tipo TEXT, fecha TEXT, evento TEXT, notas TEXT)"
        if !(db.executeStatements(sql_stmt)) {
            print("Error: \(db.lastErrorMessage())")
        }
        else {
            print("Tabla 'eventos': OK")
        }
        db.close()
    }
    else {
        print("Error: \(db.lastErrorMessage())")
    }
}

func selectMaxId(tabla: String) -> String {
    var id: String = "0"
    let db = getDB()
    if db.open() {
        let results: FMResultSet = db.executeQuery("SELECT MAX(id) + 1 AS max FROM \(tabla)", withArgumentsIn: nil)
        if results.next() == true {
            if results.string(forColumn: "max") != nil {
                id = results.string(forColumn: "max")
            }
        }
        db.close()
    }
    else {
        print("Error: \(db.lastErrorMessage())")
    }
    return id
}

func selectPersonas(esCliente: String) -> [[String:String]] {
    var personas: [[String:String]] = []
    var persona: [String:String] = ["id":"", "nombrec":"", "nombre":"", "apaterno":"", "amaterno":"", "direccion":"", "notas":"", "estatus":"", "cliente":"", "telefono":"", "correo":"", "referencia":""]
    let db = getDB()
    if db.open() {
        var query = "SELECT id, nombre||' '||apaterno||' '||amaterno AS nombrec, nombre, apaterno, amaterno, direccion, notas, estatus, cliente, referencia FROM personas WHERE cliente = \(esCliente)"
        let results: FMResultSet = db.executeQuery(query, withArgumentsIn: nil)
        while results.next() == true {
            let id: String = results.string(forColumn: "id")
            query = "SELECT telefono FROM telefonos WHERE principal = 1 AND id = \(id)"
            let res_telefono: FMResultSet = db.executeQuery(query, withArgumentsIn: nil)
            query = "SELECT correo FROM correos WHERE principal = 1 AND id = \(id)"
            let res_correo: FMResultSet = db.executeQuery(query, withArgumentsIn: nil)
            persona["id"] = results.string(forColumn: "id")
            persona["nombrec"] = results.string(forColumn: "nombrec")
            persona["nombre"] = results.string(forColumn: "nombre")
            persona["apaterno"] = results.string(forColumn: "apaterno")
            persona["amaterno"] = results.string(forColumn: "amaterno")
            persona["direccion"] = results.string(forColumn: "direccion")
            persona["notas"] = results.string(forColumn: "notas")
            persona["estatus"] = results.string(forColumn: "estatus")
            persona["cliente"] = results.string(forColumn: "cliente")
            persona["referencia"] = results.string(forColumn: "referencia")
            if res_telefono.next() == true {
                persona["telefono"] = res_telefono.string(forColumn: "telefono")
            }
            else {
                persona["telefono"] = ""
            }
            if res_correo.next() == true {
                persona["correo"] = res_correo.string(forColumn: "correo")
            }
            else {
                persona["correo"] = ""
            }
            personas.append(persona)
        }
        db.close()
    }
    else {
        print("Error: \(db.lastErrorMessage())")
    }
    return personas
}

func selectAllPersonas() -> [[String:String]] {
    var personas: [[String:String]] = []
    var persona: [String:String] = ["id":"", "nombre":"", "apaterno":"", "amaterno":""]
    let db = getDB()
    if db.open() {
        let results: FMResultSet = db.executeQuery("SELECT id, nombre||' '||apaterno||' '||amaterno AS 'nombre' FROM personas", withArgumentsIn: nil)
        while results.next() == true {
            persona["id"] = results.string(forColumn: "id")
            persona["nombre"] = results.string(forColumn: "nombre")
            personas.append(persona)
        }
        db.close()
    }
    else {
        print("Error: \(db.lastErrorMessage())")
    }
    return personas
}

func executePersonas(accion: String, persona: [String:String]) {
    var sql: String = ""
    if accion == "insert" {
        sql = "INSERT INTO personas (id, nombre, apaterno, amaterno, direccion, notas, estatus, cliente, referencia) VALUES (\(persona["id"]!), '\(persona["nombre"]!)', '\(persona["apaterno"]!)', '\(persona["amaterno"]!)', '\(persona["direccion"]!)', '\(persona["notas"]!)', '\(persona["estatus"]!)', '\(persona["cliente"]!)', '\(persona["referencia"]!)')"
    }
    else if accion == "update" {
        sql = "UPDATE personas SET nombre = '\(persona["nombre"]!)', apaterno = '\(persona["apaterno"]!)', amaterno = '\(persona["amaterno"]!)', direccion = '\(persona["direccion"]!)', notas = '\(persona["notas"]!)', estatus = '\(persona["estatus"]!)', cliente = '\(persona["cliente"]!)', referencia = '\(persona["referencia"]!)' WHERE id = \(persona["id"]!)"
    }
    else if accion == "delete" {
        sql = "DELETE FROM personas WHERE id = \(persona["id"]!)"
    }
    let db = getDB()
    if db.open() {
        let result = db.executeStatements(sql)
        if !result {
            print("Error: \(db.lastErrorMessage())")
        }
        else {
            print("'\(accion)' OK")
            db.close()
        }
    }
    else {
        print("Error: \(db.lastErrorMessage())")
    }
}

func selectTefonos(id: String) -> [[String:String]] {
    var telefonos: [[String:String]] = []
    var telefono: [String:String] = ["id":"", "idx":"", "principal":"", "telefono":"", "tipo":""]
    let db = getDB()
    if db.open() {
        let results: FMResultSet = db.executeQuery("SELECT id, idx, principal, telefono, tipo FROM telefonos WHERE id = \(id)", withArgumentsIn: nil)
        while results.next() == true {
            telefono["id"] = results.string(forColumn: "id")
            telefono["idx"] = results.string(forColumn: "idx")
            telefono["principal"] = results.string(forColumn: "principal")
            telefono["telefono"] = results.string(forColumn: "telefono")
            telefono["tipo"] = results.string(forColumn: "tipo")
            telefonos.append(telefono)
        }
        db.close()
    }
    else {
        print("Error: \(db.lastErrorMessage())")
    }
    return telefonos
}

func update(telefonos: [[String:String]], id: String) {
    let db = getDB()
    if db.open() {
        let result = db.executeStatements("DELETE FROM telefonos WHERE id = \(id)")
        if !result {
            print("Error: \(db.lastErrorMessage())")
        }
        else {
            print("DELETE telefonos")
            for telefono in telefonos {
                let sql = "INSERT INTO telefonos (id, idx, principal, telefono, tipo) VALUES (\(telefono["id"]!), \(telefono["idx"]!), \(telefono["principal"]!), '\(telefono["telefono"]!)', '\(telefono["tipo"]!)')"
                let result = db.executeStatements(sql)
                if !result {
                    print("Error: \(db.lastErrorMessage())")
                }
                else {
                    print("INSERT telefono: \(telefono["idx"]!)")
                }
            }
        }
        db.close()
    }
    else {
        print("Error: \(db.lastErrorMessage())")
    }
}

func deleteTelefonos(id: String) {
    let db = getDB()
    if db.open() {
        let result = db.executeStatements("DELETE FROM telefonos WHERE id = \(id)")
        if !result {
            print("Error: \(db.lastErrorMessage())")
        }
        else {
            print("DELETE OK")
        }
        db.close()
    }
    else {
        print("Error: \(db.lastErrorMessage())")
    }
}

func selectCorreos(id: String) -> [[String:String]] {
    var correos: [[String:String]] = []
    var correo: [String:String] = ["id":"", "idx":"", "principal":"", "correo":"", "tipo":""]
    let db = getDB()
    if db.open() {
        let results: FMResultSet = db.executeQuery("SELECT id, idx, principal, correo, tipo FROM correos WHERE id = \(id)", withArgumentsIn: nil)
        while results.next() == true {
            correo["id"] = results.string(forColumn: "id")
            correo["idx"] = results.string(forColumn: "idx")
            correo["principal"] = results.string(forColumn: "principal")
            correo["correo"] = results.string(forColumn: "correo")
            correo["tipo"] = results.string(forColumn: "tipo")
            correos.append(correo)
        }
        db.close()
    }
    else {
        print("Error: \(db.lastErrorMessage())")
    }
    return correos
}

func update(correos: [[String:String]], id: String) {
    let db = getDB()
    if db.open() {
        let result = db.executeStatements("DELETE FROM correos WHERE id = \(id)")
        if !result {
            print("Error: \(db.lastErrorMessage())")
        }
        else {
            print("DELETE correos")
            for correo in correos {
                let sql = "INSERT INTO correos (id, idx, principal, correo, tipo) VALUES (\(correo["id"]!), \(correo["idx"]!), \(correo["principal"]!), '\(correo["correo"]!)', '\(correo["tipo"]!)')"
                let result = db.executeStatements(sql)
                if !result {
                    print("Error: \(db.lastErrorMessage())")
                }
                else {
                    print("INSERT correo: \(correo["idx"]!)")
                }
            }
        }
        db.close()
    }
    else {
        print("Error: \(db.lastErrorMessage())")
    }
}

func deleteCorreos(id: String) {
    let db = getDB()
    if db.open() {
        let result = db.executeStatements("DELETE FROM correos WHERE id = \(id)")
        if !result {
            print("Error: \(db.lastErrorMessage())")
        }
        else {
            print("DELETE OK")
        }
        db.close()
    }
    else {
        print("Error: \(db.lastErrorMessage())")
    }
}

func executeEventos(accion: String, evento: [String:String]) {
    var sql: String = ""
    if accion == "insert" {
        sql = "INSERT INTO eventos (id, persona, tipo, fecha, evento, notas) VALUES (\(evento["id"]!), \(evento["persona"]!), '\(evento["tipo"]!)', '\(evento["fecha"]!)', '\(evento["evento"]!)', '\(evento["notas"]!)')"
    }
    else if accion == "update" {
        sql = "UPDATE eventos SET persona = \(evento["persona"]!), tipo = '\(evento["tipo"]!)', fecha = '\(evento["fecha"]!)', evento = '\(evento["evento"]!)', notas = '\(evento["notas"]!)' WHERE id = \(evento["id"]!)"
    }
    else if accion == "delete" {
        sql = "DELETE FROM eventos WHERE id = \(evento["id"]!)"
    }
    let db = getDB()
    if db.open() {
        let result = db.executeStatements(sql)
        if !result {
            print("Error: \(db.lastErrorMessage())")
        }
        else {
            print("'\(accion)' OK")
            db.close()
        }
    }
    else {
        print("Error: \(db.lastErrorMessage())")
    }
}
