//
//  BD.swift
//  SGalindoEcommerce
//


import Foundation
import SQLite3

class Conexion {
    
    
    var db : OpaquePointer?
    var Path : String = "Document.SGalindoEcommerce.sql"
    
    func CreateDB(){
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(Path)
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(filePath.path, &db) != SQLITE_OK{
            print("No se entro al archivo")
        }else{
            
            print("La base de datos se creo exitosamente")
            print(filePath)
        }
    
    }
    
    
    func GetAll(){
        
        
        let query = "SELECT * FROM Usuario;"
        let conexion = DBManager.init()
        let usuario = Usuario()
        
        var statement : OpaquePointer! = nil
        
        if sqlite3_prepare(conexion.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_ROW {
                
                let result = Result()
                
                usuario.IdUsuario = Int(sqlite3_column_int(statement, 0))
                usuario.Nombre = String(cString: sqlite3_column_text(statement, 1))
                usuario.ApellidoPaterno = String(cString: sqlite3_column_text(statement, 2))
                usuario.ApellidoMaterno = String(cString: sqlite3_column_text(statement, 3))
                usuario.Email = String(cString: sqlite3_column_text(statement, 4))
                
                result.Objects?.append(usuario)
                
            }
        }
    }

    

}



