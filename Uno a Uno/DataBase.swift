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
        sql_stmt = "CREATE TABLE IF NOT EXISTS personas (id INTEGER PRIMARY KEY AUTOINCREMENT, referencia INTEGER, nombre TEXT, apaterno TEXT, amaterno TEXT, direccion TEXT, notas TEXT, estatus TEXT, cliente INTEGER)"
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
        sql_stmt = "CREATE TABLE IF NOT EXISTS eventos (id INTEGER PRIMARY KEY AUTOINCREMENT, persona INTEGER, tipo TEXT, fecha TEXT, notas TEXT, recordatorio TEXT)"
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

func selectPersonas(esCliente: String) -> [[String:String]] {
    var personas: [[String:String]] = []
    var persona: [String:String] = ["id":"", "referencia":"", "nombrec":"", "nombre":"", "apaterno":"", "amaterno":"", "direccion":"", "notas":"", "estatus":"", "cliente":"", "telefono":"", "correo":""]
    let db = getDB()
    if db.open() {
        var query = "SELECT id, referencia, nombre||' '||apaterno||' '||amaterno AS nombrec, nombre, apaterno, amaterno, direccion, notas, estatus, cliente FROM personas WHERE cliente = \(esCliente)"
        let results: FMResultSet = db.executeQuery(query, withArgumentsIn: nil)
        while results.next() == true {
            query = "SELECT telefono FROM telefonos WHERE principal = 1 AND id = \(results.string(forColumn: "id")!)"
            let res_telefono: FMResultSet = db.executeQuery(query, withArgumentsIn: nil)
            query = "SELECT correo FROM correos WHERE principal = 1 AND id = \(results.string(forColumn: "id")!)"
            let res_correo: FMResultSet = db.executeQuery(query, withArgumentsIn: nil)
            persona["id"] = results.string(forColumn: "id")
            persona["referencia"] = results.string(forColumn: "referencia")
            persona["nombrec"] = results.string(forColumn: "nombrec")
            persona["nombre"] = results.string(forColumn: "nombre")
            persona["apaterno"] = results.string(forColumn: "apaterno")
            persona["amaterno"] = results.string(forColumn: "amaterno")
            persona["direccion"] = results.string(forColumn: "direccion")
            persona["notas"] = results.string(forColumn: "notas")
            persona["estatus"] = results.string(forColumn: "estatus")
            persona["cliente"] = results.string(forColumn: "cliente")
            if res_telefono.next() == true {
                persona["telefono"] = res_telefono.string(forColumn: "telefono")
            }
            if res_correo.next() == true {
                persona["correo"] = res_correo.string(forColumn: "correo")
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
        let query = "SELECT id, nombre||' '||apaterno||' '||amaterno AS 'nombre' FROM personas"
        let results: FMResultSet = db.executeQuery(query, withArgumentsIn: nil)
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
        sql = "INSERT INTO personas (referencia, nombre, apaterno, amaterno, direccion, notas, estatus, cliente) VALUES (\(persona["referencia"]!), '\(persona["nombre"]!)', '\(persona["apaterno"]!)', '\(persona["amaterno"]!)', '\(persona["direccion"]!)', '\(persona["notas"]!)', '\(persona["estatus"]!)', '\(persona["cliente"]!)')"
    }
    else if accion == "update" {
        sql = "UPDATE personas SET referencia = \(persona["referencia"]!), nombre = '\(persona["nombre"]!)', apaterno = '\(persona["apaterno"]!)', amaterno = '\(persona["amaterno"]!)', direccion = '\(persona["direccion"]!)', notas = '\(persona["notas"]!)', estatus = '\(persona["estatus"]!)', cliente = '\(persona["cliente"]!)' WHERE id = \(persona["id"]!)"
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
        let query = "SELECT id, idx, principal, telefono, tipo FROM telefonos WHERE id = \(id)"
        let results: FMResultSet = db.executeQuery(query, withArgumentsIn: nil)
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

func update(telefonos: [[String:String]]) {
    let db = getDB()
    if db.open() {
        var sql = "DELETE FROM telefonos WHERE id = \(telefonos[0]["id"]!)"
        let result = db.executeStatements(sql)
        if !result {
            print("Error: \(db.lastErrorMessage())")
        }
        else {
            print("DELETE OK")
            for telefono in telefonos {
                sql = "INSERT INTO telefonos (id, idx, principal, telefono, tipo) VALUES (\(telefono["id"]!), \(telefono["idx"]!), \(telefono["principal"]!), '\(telefono["telefono"]!)', '\(telefono["tipo"]!)')"
                let result = db.executeStatements(sql)
                if !result {
                    print("Error: \(db.lastErrorMessage())")
                }
                else {
                    print("INSERT OK")
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
    let sql = "DELETE FROM telefonos WHERE id = \(id)"
    let db = getDB()
    if db.open() {
        let result = db.executeStatements(sql)
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
        let query = "SELECT id, idx, principal, correo, tipo FROM correos WHERE id = \(id)"
        let results: FMResultSet = db.executeQuery(query, withArgumentsIn: nil)
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

func update(correos: [[String:String]]) {
    var sql = "DELETE FROM correos WHERE id = \(correos[0]["id"]!)"
    let db = getDB()
    if db.open() {
        let result = db.executeStatements(sql)
        if !result {
            print("Error: \(db.lastErrorMessage())")
        }
        else {
            print("DELETE OK")
            for correo in correos {
                sql = "INSERT INTO correos (id, idx, principal, correo, tipo) VALUES (\(correo["id"]!), \(correo["idx"]!), \(correo["principal"]!), '\(correo["correo"]!)', '\(correo["tipo"]!)')"
                let result = db.executeStatements(sql)
                if !result {
                    print("Error: \(db.lastErrorMessage())")
                }
                else {
                    print("INSERT OK")
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
    let sql = "DELETE FROM correos WHERE id = \(id)"
    let db = getDB()
    if db.open() {
        let result = db.executeStatements(sql)
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
