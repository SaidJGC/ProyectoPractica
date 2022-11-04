//
//  Departamento.swift
//  SGalindoEcommerce
//


import Foundation
import SQLite3

class Departamento {
    
    var IdDepartamento : Int = 0
    var Nombre : String = ""
    var area = Area()
    var Departamentos : [Departamento]?
    
    
    
    
    
    static func GetAll() -> Result {
        
        let result = Result()
        
        var statement : OpaquePointer! = nil
        let query = "SELECT IdDepartamento, Nombre, IdArea FROM Departamento;"
        let conexion = DBManager.init()
        
        do{
            
            if sqlite3_prepare(conexion.db, query, -1, &statement, nil) == SQLITE_OK {
                
                result.Objects = [Any]()
                while (sqlite3_step(statement) == SQLITE_ROW){
                    
                    let departamento = Departamento()
                    
                    
                    departamento.IdDepartamento = Int(sqlite3_column_int(statement, 0))
                    departamento.Nombre = String(cString: sqlite3_column_text(statement, 1))
                    departamento.area.IdArea = Int(sqlite3_column_int(statement, 3))
                    
                    result.Objects?.append(departamento)
                    
                   
                    result.Correct = true
                }
            }
            else{
                result.Correct = false
                result.ErrorMessage = "No se encontro informacion"
            }
        }catch let error{
            
            result.Correct = false
            result.Ex = error
            result.ErrorMessage = error.localizedDescription
        
        }
        sqlite3_finalize(statement)
        sqlite3_close(conexion.db)
        return result
    }
    
    static func GetByArea(_ idArea : Int) -> Result {
        
        let result = Result()
        
        var statement : OpaquePointer! = nil
        let query = "SELECT IdDepartamento, Nombre, IdArea FROM Departamento WHERE IdArea = '\(idArea)';"
        let conexion = DBManager.init()
        
        do{
            
            if sqlite3_prepare(conexion.db, query, -1, &statement, nil) == SQLITE_OK {
                
                result.Objects = [Any]()
                while (sqlite3_step(statement) == SQLITE_ROW){
                    
                    let departamento = Departamento()
                    
                    
                    departamento.IdDepartamento = Int(sqlite3_column_int(statement, 0))
                    departamento.Nombre = String(cString: sqlite3_column_text(statement, 1))
                    departamento.area.IdArea = Int(sqlite3_column_int(statement, 3))
                    
                    result.Objects?.append(departamento)
                    
                   
                    result.Correct = true
                }
            }
            else{
                result.Correct = false
                result.ErrorMessage = "No se encontro informacion"
            }
        }catch let error{
            
            result.Correct = false
            result.Ex = error
            result.ErrorMessage = error.localizedDescription
        
        }
        sqlite3_finalize(statement)
        sqlite3_close(conexion.db)
        return result
    }
    
}
