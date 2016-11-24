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
        sql_stmt = "CREATE TABLE IF NOT EXISTS personas (id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT, apaterno TEXT, amaterno TEXT, telefono TEXT, tipo_telefono TEXT, correo TEXT, tipo_correo TEXT, direccion TEXT, notas TEXT, estatus TEXT, cliente TEXT)"
        if !(db.executeStatements(sql_stmt)) {
            print("Error: \(db.lastErrorMessage())")
        }
        else {
            print("Tabla 'personas': OK")
        }
        sql_stmt = "CREATE TABLE IF NOT EXISTS referidos (persona INTEGER, referido INTEGER)"
        if !(db.executeStatements(sql_stmt)) {
            print("Error: \(db.lastErrorMessage())")
        }
        else {
            print("Tabla 'referidos': OK")
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

func selectAllPersonas() -> [[String:String]] {
    var clientes: [[String:String]] = []
    var cliente: [String:String] = ["id":"", "nombre":"", "apaterno":"", "amaterno":"", "telefono":""]
    let db = getDB()
    if db.open() {
        let querySQL = "SELECT id, nombre, apaterno, amaterno, telefono, estatus FROM personas"
        let results: FMResultSet = db.executeQuery(querySQL, withArgumentsIn: nil)
        while results.next() == true {
            cliente["id"] = results.string(forColumn: "id_cliente")
            cliente["nombre"] = results.string(forColumn: "nombre")
            cliente["apaterno"] = results.string(forColumn: "apaterno")
            cliente["amaterno"] = results.string(forColumn: "amaterno")
            cliente["telefono"] = results.string(forColumn: "telefono")
            cliente["estatus"] = results.string(forColumn: "estatus")
            clientes.append(cliente)
        }
        db.close()
    } else {
        print("Error: \(db.lastErrorMessage())")
    }
    return clientes
}

func selectAllPersonas(clientes: String) -> [[String:String]] {
    var clientes: [[String:String]] = []
    var cliente: [String:String] = ["id":"", "nombre":"", "apaterno":"", "amaterno":"", "telefono":""]
    let db = getDB()
    if db.open() {
        let querySQL = "SELECT id, nombre, apaterno, amaterno, telefono, estatus FROM personas WHERE cliente = '\(clientes)'"
        let results: FMResultSet = db.executeQuery(querySQL, withArgumentsIn: nil)
        while results.next() == true {
            cliente["id"] = results.string(forColumn: "id_cliente")
            cliente["nombre"] = results.string(forColumn: "nombre")
            cliente["apaterno"] = results.string(forColumn: "apaterno")
            cliente["amaterno"] = results.string(forColumn: "amaterno")
            cliente["telefono"] = results.string(forColumn: "telefono")
            cliente["estatus"] = results.string(forColumn: "estatus")
            clientes.append(cliente)
        }
        db.close()
    } else {
        print("Error: \(db.lastErrorMessage())")
    }
    return clientes
}

func ejecutarEnPersonas(accion: String, persona: [String:String]) {
    var sql: String = ""
    if accion == "insert" {
        sql = "INSERT INTO personas (nombre, apaterno, amaterno, telefono, tipo_telefono, correo, tipo_correo, direccion, notas, estatus, cliente) VALUES ('\(persona["nombre"]!)', '\(persona["apaterno"]!)', '\(persona["amaterno"]!)', '\(persona["telefono"]!)', '\(persona["tipo_telefono"]!)', '\(persona["correo"]!)', '\(persona["tipo_correo"]!)', '\(persona["estatus"]!)')"
    }
    else if accion == "update" {
        sql = "UPDATE personas SET nombre = '\(persona["nombre"]!)', apaterno = '\(persona["apaterno"]!)', amaterno = '\(persona["amaterno"]!)', telefono = '\(persona["telefono"]!)' WHERE id = \(persona["id"]!)"
    }
    else if accion == "delete" {
        sql = "DELETE FROM personas WHERE id = \(persona["id"]!)"
    }
    let db = getDB()
    if db.open() {
        let result = db.executeUpdate(sql, withArgumentsIn: nil)
        if !result {
            print("Error: \(db.lastErrorMessage())")
        }
    } else {
        print("Error: \(db.lastErrorMessage())")
    }
}
