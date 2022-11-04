//
//  Usuario.swift
//  SGalindoEcommerce
//


import Foundation
import SQLite3

class Usuario {
    
    var IdUsuario : Int = 0
    var Nombre : String = ""
    var ApellidoPaterno : String = ""
    var ApellidoMaterno : String = ""
    var Email : String = ""
    var Password :String = ""
    var Imagen : String = ""
    var Usuarios : [Usuario]?
    
    
    static func Add(_ usuario : Usuario) -> Result{
        
        let result = Result()
        let query = "INSERT INTO Usuario(Nombre, ApellidoPaterno, ApellidoMaterno, Email, Password, Imagen) VALUES(?,?,?,?,?,?);"
        let conexion = DBManager.init()
        
        var statement : OpaquePointer! = nil
        
        if sqlite3_prepare(conexion.db, query, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (usuario.Nombre as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (usuario.ApellidoPaterno as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (usuario.ApellidoMaterno as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (usuario.Email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, (usuario.Password as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 6, (usuario.Imagen as NSString).utf8String, -1, nil)
            
            
            if sqlite3_step(statement) == SQLITE_DONE {
                
                print("Producto agregado exitosamente")
                result.Correct = true
                
            }else {
                result.ErrorMessage = "Ocurrio un error al actualizar el usuario"
                result.Correct = false
                print(sqlite3_step(statement))
            }
        }
        sqlite3_finalize(statement)
        sqlite3_close(conexion.db)
        return result
    }
    
    
    
    static func Update(_ usuario : Usuario) -> Result{
        let result = Result()
        
        let conexion = DBManager.init()
        var statement : OpaquePointer?
        do{
            let query = "UPDATE Usuario SET Nombre = ?, ApellidoPaterno = ?, ApellidoMaterno = ?, Email = ?, Password = ?, Imagen = ? WHERE IdUsuario = \(usuario.IdUsuario);"
            
//            let query2 = "SELECT * FROM alumnos WHERE fecha_nacimiento < :fecha"
//            let query = #" UPDATE Usuario SET Nombre = '\#(usuario.Nombre)', ApellidoPaterno = '\#(usuario.ApellidoPaterno)', ApellidoMaterno = '\#(usuario.ApellidoMaterno)', Email = '\#(usuario.Email)' WHERE IdUsuario = \#(usuario.IdUsuario);"#
//                        
            
            if sqlite3_prepare_v2(conexion.db, query, -1, &statement, nil) == SQLITE_OK{
                
                sqlite3_bind_text(statement, 1, (usuario.Nombre as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 2, (usuario.ApellidoPaterno as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 3, (usuario.ApellidoMaterno as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 4, (usuario.Email as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 5, (usuario.Password as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 6, (usuario.Imagen as NSString).utf8String, -1, nil)
                
                
                if sqlite3_step(statement) == SQLITE_DONE {
                    result.Correct = true
                    print("Usuario actualizado")
                    
                }else {
                    
                    let errmsg = String(cString: sqlite3_errmsg(conexion.db))
                    print("Ocurrion un fallo \(errmsg)")
                    
                    print("No se pudieron actualizar los datos")
                }
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
    
    
    
    static func GetAll() -> Result {
        
        let result = Result()
        
        var statement : OpaquePointer! = nil
        let query = "SELECT IdUsuario, Nombre, ApellidoPaterno, ApellidoMaterno, Email, Password, Imagen FROM Usuario;"
        let conexion = DBManager.init()
        
        do{
            
            if sqlite3_prepare(conexion.db, query, -1, &statement, nil) == SQLITE_OK {
                
                result.Objects = [Any]()
                
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    
                    let usuario = Usuario()
                    
                    usuario.IdUsuario = Int(sqlite3_column_int(statement, 0))
                    usuario.Nombre = String(cString: sqlite3_column_text(statement, 1))
                    usuario.ApellidoPaterno = String(cString: sqlite3_column_text(statement, 2))
                    usuario.ApellidoMaterno = String(cString: sqlite3_column_text(statement, 3))
                    usuario.Email = String(cString: sqlite3_column_text(statement, 4))
                    usuario.Password = String(cString: sqlite3_column_text(statement, 5))
                    if sqlite3_column_text(statement, 6) != nil {
                        usuario.Imagen = String(cString: sqlite3_column_text(statement, 6))
                    }else{
                        usuario.Imagen = ""
                    }
                    
                    result.Objects?.append(usuario) //OBJECT NO REFERENCES
                    
                }
                result.Correct = true
            }
            else{
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
    
    
    static func Delete(_ IdUsuario: Int){
            var query = "DELETE FROM Usuario WHERE IdUsuario = \(IdUsuario)"
            var statement : OpaquePointer? = nil
            let conexion = DBManager.init()
            
            if sqlite3_prepare_v2(conexion.db, query, -1, &statement, nil) == SQLITE_OK{
                if sqlite3_step(statement) == SQLITE_DONE {
                    print("Usuario eliminado correctamente")
                }else {
                    print("Error al eliminar el usuario")
                }
            }
        sqlite3_finalize(statement)
        sqlite3_close(conexion.db)
        }
    
    
    
    static func GetById(_ IdUsuario : Int) -> Result {
        
        let result = Result()
        
        var statement : OpaquePointer! = nil
        let query = "SELECT IdUsuario, Nombre, ApellidoPaterno, ApellidoMaterno, Email, Password, Imagen FROM Usuario WHERE IdUsuario = \(IdUsuario);"
        let conexion = DBManager.init()
        
        do{
            
            if sqlite3_prepare(conexion.db, query, -1, &statement, nil) == SQLITE_OK {
                
                if (sqlite3_step(statement) == SQLITE_ROW){
                    
                    let usuario = Usuario()
                    
                    usuario.IdUsuario = Int(sqlite3_column_int(statement, 0))
                    usuario.Nombre = String(cString: sqlite3_column_text(statement, 1))
                    usuario.ApellidoPaterno = String(cString: sqlite3_column_text(statement, 2))
                    usuario.ApellidoMaterno = String(cString: sqlite3_column_text(statement, 3))
                    usuario.Email = String(cString: sqlite3_column_text(statement, 4))
                    usuario.Password = String(cString: sqlite3_column_text(statement, 5))
                    if sqlite3_column_text(statement, 6) != nil {
                        usuario.Imagen = String(cString: sqlite3_column_text(statement, 6))
                    }else{
                        usuario.Imagen = ""
                    }
                    
                    result.Object = usuario
                    
                   
                }
                result.Correct = true
            }
            else{
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
    
    
 
    
    static func GetByEmail(_ email : String) -> Result {
        
        let result = Result()
        
        var statement : OpaquePointer! = nil
        let query = "SELECT IdUsuario, Nombre, ApellidoPaterno, ApellidoMaterno, Email, Password, Imagen FROM Usuario WHERE Email = '\(email)';"
        let conexion = DBManager.init()
        
        do{
            
            if sqlite3_prepare(conexion.db, query, -1, &statement, nil) == SQLITE_OK {
                
                if (sqlite3_step(statement) == SQLITE_ROW){
                    
                    let usuario = Usuario()
                    
                    usuario.IdUsuario = Int(sqlite3_column_int(statement, 0))
                    usuario.Nombre = String(cString: sqlite3_column_text(statement, 1))
                    usuario.ApellidoPaterno = String(cString: sqlite3_column_text(statement, 2))
                    usuario.ApellidoMaterno = String(cString: sqlite3_column_text(statement, 3))
                    usuario.Email = String(cString: sqlite3_column_text(statement, 4))
                    usuario.Password = String(cString: sqlite3_column_text(statement, 5))
                    if sqlite3_column_text(statement, 6) != nil {
                        usuario.Imagen = String(cString: sqlite3_column_text(statement, 6))
                    }else{
                        usuario.Imagen = ""
                    }
                    
                    
                    result.Object = usuario
                    
                   
                    result.Correct = true
                }else{
                    
                    result.Correct = false
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
