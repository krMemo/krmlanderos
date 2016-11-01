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
        sql_stmt = "CREATE TABLE IF NOT EXISTS clientes (id_cliente INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT, apaterno TEXT, amaterno TEXT, telefono TEXT)"
        if !(db.executeStatements(sql_stmt)) {
            print("Error: \(db.lastErrorMessage())")
        }
        else {
            print("Tabla clientes: OK")
        }
        sql_stmt = "CREATE TABLE IF NOT EXISTS referidos (id_referido INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT, apaterno TEXT, amaterno TEXT, telefono TEXT)"
        if !(db.executeStatements(sql_stmt)) {
            print("Error: \(db.lastErrorMessage())")
        }
        else {
            print("Tabla referidos: OK")
        }
        db.close()
    }
    else {
        print("Error: \(db.lastErrorMessage())")
    }
}

func selectAllClientes() -> [[String:String]] {
    var clientes: [[String:String]] = []
    var cliente: [String:String] = ["id":"", "nombre":"", "apaterno":"", "amaterno":"", "telefono":""]
    let db = getDB()
    if db.open() {
        let querySQL = "SELECT id_cliente, nombre, apaterno, amaterno, telefono FROM clientes"
        let results: FMResultSet = db.executeQuery(querySQL, withArgumentsIn: nil)
        while results.next() == true {
            cliente["id"] = results.string(forColumn: "id_cliente")
            cliente["nombre"] = results.string(forColumn: "nombre")
            cliente["apaterno"] = results.string(forColumn: "apaterno")
            cliente["amaterno"] = results.string(forColumn: "amaterno")
            cliente["telefono"] = results.string(forColumn: "telefono")
            clientes.append(cliente)
        }
        db.close()
    } else {
        print("Error: \(db.lastErrorMessage())")
    }
    return clientes
}

func selectAllReferidos() -> [[String:String]] {
    var clientes: [[String:String]] = []
    var cliente: [String:String] = ["id":"", "nombre":"", "apaterno":"", "amaterno":"", "telefono":""]
    let db = getDB()
    if db.open() {
        let querySQL = "SELECT id_referido, nombre, apaterno, amaterno, telefono FROM referidos"
        let results: FMResultSet = db.executeQuery(querySQL, withArgumentsIn: nil)
        while results.next() == true {
            cliente["id"] = results.string(forColumn: "id_referido")
            cliente["nombre"] = results.string(forColumn: "nombre")
            cliente["apaterno"] = results.string(forColumn: "apaterno")
            cliente["amaterno"] = results.string(forColumn: "amaterno")
            cliente["telefono"] = results.string(forColumn: "telefono")
            clientes.append(cliente)
        }
        db.close()
    } else {
        print("Error: \(db.lastErrorMessage())")
    }
    return clientes
}

func ejecutarenClientes(accion: String, persona: [String:String]) {
    var sql: String = ""
    if accion == "insert" {
        sql = "INSERT INTO clientes (nombre, apaterno, amaterno, telefono) VALUES ('\(persona["nombre"]!)', '\(persona["apaterno"]!)', '\(persona["amaterno"]!)', '\(persona["telefono"]!)')"
    }
    else if accion == "update" {
        sql = "UPDATE clientes SET nombre = '\(persona["nombre"]!)', apaterno = '\(persona["apaterno"]!)', amaterno = '\(persona["amaterno"]!)', telefono = '\(persona["telefono"]!)' WHERE id_cliente = \(persona["id"]!)"
    }
    else if accion == "delete" {
        sql = "DELETE FROM clientes WHERE id_cliente = \(persona["id"]!)"
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

func ejecutarenReferidos(accion: String, persona: [String:String]) {
    var sql: String = ""
    if accion == "insert" {
        sql = "INSERT INTO referidos (nombre, apaterno, amaterno, telefono) VALUES ('\(persona["nombre"]!)', '\(persona["apaterno"]!)', '\(persona["amaterno"]!)', '\(persona["telefono"]!)')"
    }
    else if accion == "update" {
        sql = "UPDATE referidos SET nombre = '\(persona["nombre"]!)', apaterno = '\(persona["apaterno"]!)', amaterno = '\(persona["amaterno"]!)', telefono = '\(persona["telefono"]!)' WHERE id_cliente = \(persona["id"]!)"
    }
    else if accion == "delete" {
        sql = "DELETE FROM referidos WHERE id_cliente = \(persona["id"]!)"
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
