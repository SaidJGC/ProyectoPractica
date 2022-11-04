//
//  Proveedor.swift
//  SGalindoEcommerce
//


import Foundation
import SQLite3

class Proveedor {
    
    var IdProveedor : Int = 0
    var Nombre : String = ""
    var Telefono : String = ""
    var Imagen : String = ""
    var Proveedores : [Proveedor]?
    
    
    
    static func Add(_ proveedor : Proveedor) -> Result {
        let result = Result()
        var statement : OpaquePointer! = nil
        let query = "INSERT INTO Proveedor (Nombre, Telefono, Imagen) VALUES (?, ?, ?);"
        let conexion = DBManager.init()
        
        do{
            
            if sqlite3_prepare(conexion.db, query, -1, &statement, nil) == SQLITE_OK{
                
                sqlite3_bind_text(statement, 1, (proveedor.Nombre as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 2, (proveedor.Telefono as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 3, (proveedor.Imagen as NSString).utf8String, -1, nil)
            }
            
            if sqlite3_step(statement) == SQLITE_DONE {
                
                result.Correct = true
                print("Proveedor agregado exitosamente")
                
            }else   {
                
                result.Correct = false
                result.ErrorMessage = "Ocurrio un error al agregar el Proveedor"
            }
        }
        sqlite3_finalize(statement)
        sqlite3_close(conexion.db)
        return result
    }
    
    static func Update(_ proveedor : Proveedor) -> Result {
        let result = Result()
        var statement : OpaquePointer! = nil
        let query = "Update Proveedor SET Nombre = ?, Telefono = ?, Imagen = ? WHERE IdProveedor = \(proveedor.IdProveedor)"
        let conexion = DBManager.init()
        
        do{
            
            if sqlite3_prepare(conexion.db, query, -1, &statement, nil) == SQLITE_OK{
                
                sqlite3_bind_text(statement, 1, (proveedor.Nombre as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 2, (proveedor.Telefono as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 3, (proveedor.Imagen as NSString).utf8String, -1, nil)
            }
            
            if sqlite3_step(statement) == SQLITE_DONE {
                
                result.Correct = true
                print("Proveedor agregado exitosamente")
                
            }else   {
                
                result.ErrorMessage = "Ocurrio un error al agregar el Proveedor"
            }
        }
        sqlite3_finalize(statement)
        sqlite3_close(conexion.db)
        return result
    }
    
    static func GetAll() -> Result {
        
        let result = Result()
        
        var statement : OpaquePointer! = nil
        let query = "SELECT IdProveedor, Nombre, Telefono, Imagen  FROM Proveedor;"
        let conexion = DBManager.init()
        
        do{
            
            if sqlite3_prepare(conexion.db, query, -1, &statement, nil) == SQLITE_OK {
                
                result.Objects = [Any]()
                while (sqlite3_step(statement) == SQLITE_ROW){
                    
                    let proveedor = Proveedor()
                    
                    
                    proveedor.IdProveedor = Int(sqlite3_column_int(statement, 0))
                    proveedor.Nombre = String(cString: sqlite3_column_text(statement, 1))
                    proveedor.Telefono = String(cString: sqlite3_column_text(statement, 2))
                    
                    if sqlite3_column_text(statement, 3) != nil{
                        proveedor.Imagen = String(cString: sqlite3_column_text(statement, 3))
                    }else{
                        proveedor.Imagen = ""
                    }
                    
                    result.Objects?.append(proveedor)
                    
                   
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
    
    static func GetbyId(_ idProveedor :Int ) -> Result{
        
        let result = Result()
        
        var statement : OpaquePointer! = nil
        let query = "SELECT IdProveedor, Nombre, Telefono, Imagen  FROM Proveedor WHERE IdProveedor = '\(idProveedor)';"
        let conexion = DBManager.init()
        
        do{
            if sqlite3_prepare(conexion.db, query, -1, &statement, nil) == SQLITE_OK {
                
                if sqlite3_step(statement) == SQLITE_ROW {
                    
                    let proveedor = Proveedor()
                    
                    
                    proveedor.IdProveedor = Int(sqlite3_column_int(statement, 0))
                    proveedor.Nombre = String(cString: sqlite3_column_text(statement, 1))
                    proveedor.Telefono = String(cString: sqlite3_column_text(statement, 2))
                    if sqlite3_column_text(statement, 3) != nil{
                        proveedor.Imagen = String(cString: sqlite3_column_text(statement, 3))
                    }else{
                        proveedor.Imagen = ""
                    }
                    
                    result.Object = proveedor
                    
                    result.Correct = true
                    
                }else{
                    
                    result.ErrorMessage = "Error al buscar informacion"
                    result.Correct = false
                }
                
            }
            
        }catch let error {
            
            result.Correct = false
            result.Ex = error
            result.ErrorMessage = error.localizedDescription
        }
        sqlite3_finalize(statement)
        sqlite3_close(conexion.db)
        
        return result
    }
    
    static func Delete(_ idProveedor : Int) -> Result {
        
        let result = Result()
        let query = "DELETE FROM Proveedor Where IdProveedor = '\(idProveedor)'"
        var statement : OpaquePointer! = nil
        
        let conexion = DBManager.init()
        
        if sqlite3_prepare(conexion.db, query, -1, &statement, nil) == SQLITE_OK {
            
            if sqlite3_step(statement) == SQLITE_DONE {
                result.Correct = true
                print("Proveedor eliminado correctamente")
                
            }else {
                result.Correct = false
                print("Error al eliminar el Proveedor")
            }
        }
        sqlite3_finalize(statement)
        sqlite3_close(conexion.db)
        
        return result
    }
}
