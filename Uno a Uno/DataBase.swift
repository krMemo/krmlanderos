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
    let db = getDB()
    if db.open() {
        let sql_stmt = "CREATE TABLE IF NOT EXISTS clientes (id_cliente INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT)"
        if !(db.executeStatements(sql_stmt)) {
            print("Error: \(db.lastErrorMessage())")
        }
        db.close()
    }
    else {
        print("Error: \(db.lastErrorMessage())")
    }
}

func insertRegistro() {
    let db = getDB()
    if db.open() {
        let insertSQL = "INSERT INTO clientes (nombre) VALUES ('Enrique')"
        let result = db.executeUpdate(insertSQL, withArgumentsIn: nil)
        if !result {
            print("Error: \(db.lastErrorMessage())")
        } else {
            print("Cliente +")
        }
    } else {
        print("Error: \(db.lastErrorMessage())")
    }
}

func selectClientes() -> [String] {
    var clientes: [String] = []
    let db = getDB()
    if db.open() {
        let querySQL = "SELECT id_cliente, nombre FROM clientes"
        let results: FMResultSet = db.executeQuery(querySQL, withArgumentsIn: nil)
        while results.next() == true {
            clientes.append(results.string(forColumn: "nombre"))
        }
        db.close()
    } else {
        print("Error: \(db.lastErrorMessage())")
    }
    return clientes
}

func selectCountRegistro() {
    
    let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let docsDir: String = dirPaths[0]
    let databasePath = docsDir + "/UaU.db"
    
    let contactDB = FMDatabase(path: databasePath as String)
    
    if contactDB!.open() {
        let querySQL = "SELECT * FROM clientes"
        
        let results: FMResultSet = contactDB!.executeQuery(querySQL, withArgumentsIn: nil)
        
        if results.next() == true {
            print(results.string(forColumn: "nombre"))
            print(results.string(forColumn: "id_cliente"))
        } else {
            print("no hay")
        }
        contactDB!.close()
    } else {
        print("Error: \(contactDB!.lastErrorMessage())")
    }
}
