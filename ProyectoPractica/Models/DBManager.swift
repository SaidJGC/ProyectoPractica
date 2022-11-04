//
//  DBManager.swift
//  SGalindoEcommerce
//


import Foundation
import SQLite3
  
  
class DBManager
{
    init()
    {
        db = openDatabase()
    }
    
    
    let dbPath: String = "Document.SGalindoEcommerce.sql"
    var db:OpaquePointer?
    
    
    func openDatabase() -> OpaquePointer?
    {
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathExtension(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(filePath.path, &db) != SQLITE_OK
        {
            debugPrint("can't open database")
            return nil
        }
        else
        {
            print("Successfully created connection to database at \(filePath)")
            return db
        }
    }
    
}
