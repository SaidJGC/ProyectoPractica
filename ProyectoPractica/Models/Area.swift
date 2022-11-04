//
//  Area.swift
//  SGalindoEcommerce
//


import Foundation
import SQLite3

class Area {
    
    var IdArea : Int = 0
    var Nombre : String = ""
    
    static func GetAll()  -> Result{
        
        let result = Result()
        
        var statement : OpaquePointer! = nil
        let query = "SELECT IdArea, Nombre FROM Area"
        
        let conexion = DBManager.init()
        
        do{
            
            if sqlite3_prepare(conexion.db, query, -1, &statement, nil) == SQLITE_OK{
                
                result.Objects = [Any]()
                
                while (sqlite3_step(statement)) == SQLITE_ROW {
                    
                    let area = Area()
                    
                    area.IdArea = Int(sqlite3_column_int(statement, 0))
                    area.Nombre = String(cString: sqlite3_column_text(statement, 1))
                    
                    result.Objects?.append(area)
                }
                result.Correct = true
            }else   {
                result.Correct = false
                result.ErrorMessage = "No se encontro informacion"
            }
            
        }catch let error{
            result.Correct = false
            result.ErrorMessage = error.localizedDescription
        }
        sqlite3_finalize(statement)
        sqlite3_close(conexion.db)
        return result
    }
}
