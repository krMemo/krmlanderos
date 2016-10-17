//
//  DataBase.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 13/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import Foundation

func abrirDB() {
    
    let filemgr = FileManager.default
    let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let docsDir: String = dirPaths[0]
    let databasePath = docsDir + "/UaU.db"

    if !filemgr.fileExists(atPath: databasePath as String) {
        let contactDB = FMDatabase(path: databasePath as String)
        
        if contactDB == nil {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
    
        if contactDB!.open() {
            let sql_stmt = "CREATE TABLE IF NOT EXISTS clientes (id_cliente INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT)"
            if !(contactDB!.executeStatements(sql_stmt)) {
                print("Error: \(contactDB!.lastErrorMessage())")
            }
            contactDB!.close()
        }
        else {
            print("Error: \(contactDB!.lastErrorMessage())")
        }
    }
    
}

func insertRegistro() {
    
    let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let docsDir: String = dirPaths[0]
    let databasePath = docsDir + "/UaU.db"
    
    let contactDB = FMDatabase(path: databasePath as String)
    
    if contactDB!.open() {
        
        let insertSQL = "INSERT INTO clientes (nombre) VALUES ('Enrique')"
        let result = contactDB!.executeUpdate(insertSQL, withArgumentsIn: nil)
        
        if !result {
            print("Error: \(contactDB!.lastErrorMessage())")
        } else {
            print("Contact Added")
        }
    } else {
        print("Error: \(contactDB!.lastErrorMessage())")
    }
}

func selectRegistro() {
    
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
