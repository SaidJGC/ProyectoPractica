//
//  Producto.swift
//  SGalindoEcommerce
//

import Foundation
import SQLite3

class Producto {
    
    var IdProducto : Int = 0
    var Nombre : String = ""
    var Descripcion : String = ""
    var PrecioUnitario : Double = 0
    var Stock : Int = 0
    var Imagen : String = ""
    var departamento = Departamento()
    var proveedor = Proveedor()
    var Productos : [Producto]?

    
    
    static func Add(_ producto: Producto) -> Result{
        let result = Result()
        
        var statement : OpaquePointer! = nil
        let conexion = DBManager.init()
        do{
            //let query = "UPDATE Usuario SET Nombre = ?, ApellidoPaterno = ?, ApellidoMaterno = ?, Email = ? WHERE IdUsuario = \(usuario.IdUsuario);"
            
            let query = "INSERT INTO Producto (Nombre, Descripcion, PrecioUnitario, Stock, IdProveedor, IdDepartamento, Imagen) VALUES (?, ?, ?, ?, ?, ?, ?);"
                        
            
            
            if sqlite3_prepare_v2(conexion.db, query, -1, &statement, nil) == SQLITE_OK{
                
                sqlite3_bind_text(statement, 1, (producto.Nombre as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 2, (producto.Descripcion as NSString).utf8String, -1, nil)
                sqlite3_bind_double(statement, 3, producto.PrecioUnitario)
                sqlite3_bind_int(statement, 4, Int32(producto.Stock))
                sqlite3_bind_int(statement, 5, Int32(producto.proveedor.IdProveedor))
                sqlite3_bind_int(statement, 6, Int32(producto.departamento.IdDepartamento))
                sqlite3_bind_text(statement, 7, (producto.Imagen as NSString).utf8String, -1, nil)
                
                //sqlite3_bind_text(statement, 4, (usuario.Email as NSString).utf8String, -1, nil)
                
                
                if sqlite3_step(statement) == SQLITE_DONE {
                    
                    print("Producto agregado exitosamente")
                    result.Correct = true
                    
                }else {
                    result.ErrorMessage = "Ocurrio un error al actualizar el usuario"
                    result.Correct = false
                    print(sqlite3_step(statement))
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
    
    
    
    static func Update(_ producto: Producto) -> Result{
        let result = Result()
        
        var statement : OpaquePointer! = nil
        let conexion = DBManager.init()
        do{
            
            
            let query = "UPDATE Producto SET Nombre = ?, Descripcion = ?, PrecioUnitario = ?, Stock = ?, IdProveedor = ?, Imagen = ? IdDepartamento = ? WHERE IdProducto = \(producto.IdProducto);"

            
            if sqlite3_prepare_v2(conexion.db, query, -1, &statement, nil) == SQLITE_OK{
                
                sqlite3_bind_text(statement, 1, (producto.Nombre as NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 2, (producto.Descripcion as NSString).utf8String, -1, nil)
                sqlite3_bind_double(statement, 3, producto.PrecioUnitario)
                sqlite3_bind_int(statement, 4, Int32(producto.Stock))
                sqlite3_bind_int(statement, 5, Int32(producto.proveedor.IdProveedor))
                sqlite3_bind_text(statement, 6, (producto.Imagen as NSString).utf8String, -1, nil)
                sqlite3_bind_int(statement, 7, Int32(producto.departamento.IdDepartamento))
               
                
                
                
                
                if sqlite3_step(statement) == SQLITE_DONE {
                    
                    print("Producto actualizado exitosamente")
                    result.Correct = true
                    
                }else {
                    result.ErrorMessage = "Ocurrio un error al actualizar el usuario"
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
        let query = #"SELECT IdProducto, Producto.Nombre, PrecioUnitario, Stock, Descripcion, Producto.Imagen, Producto.IdDepartamento, Departamento.Nombre, Producto.IdProveedor, Proveedor.Nombre, Proveedor.Telefono, Departamento.IdArea, Area.Nombre FROM Producto INNER JOIN Departamento on Departamento.IdDepartamento = Producto.IdDepartamento INNER JOIN Proveedor on Proveedor.IdProveedor = Producto.IdProveedor INNER JOIN Area on Departamento.IdArea = Area.IdArea"#
        
        let conexion = DBManager.init()
        
        do{
            
            if sqlite3_prepare(conexion.db, query, -1, &statement, nil) == SQLITE_OK {
                
                result.Objects = [Any]()
                
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    
                    let producto = Producto()
                    
                    
                    producto.IdProducto = Int(sqlite3_column_int(statement, 0))
                    producto.Nombre = String(cString: sqlite3_column_text(statement, 1))
                    producto.PrecioUnitario = Double(sqlite3_column_double(statement, 2))
                    producto.Stock = Int(sqlite3_column_int(statement, 3))
                    producto.Descripcion = String(cString: sqlite3_column_text(statement, 4))
                    if sqlite3_column_text(statement, 5) != nil {
                        producto.Imagen = String(cString: sqlite3_column_text(statement, 5))
                    }else{
                        producto.Imagen = ""
                    }
                    producto.departamento.Nombre = String(cString: sqlite3_column_text(statement, 7))
                    producto.proveedor.Nombre = String(cString: sqlite3_column_text(statement, 9))
                    
                    result.Objects?.append(producto) //OBJECT NO REFERENCES
                    
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
    
    
    static func Delete(_ IdProducto: Int) -> Result{
        
        var result = Result()
        var query = "DELETE FROM Producto WHERE IdProducto = \(IdProducto)"
        var statement : OpaquePointer? = nil
        let conexion = DBManager.init()
            
        if sqlite3_prepare_v2(conexion.db, query, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Producto eliminado correctamente")
                result.Correct = true
            }else {
                print("Error al eliminar el Producto")
                result.Correct = false
            }
        }
        sqlite3_finalize(statement)
        sqlite3_close(conexion.db)
        return result
        }
    
    
    
    static func GetById(_ IdProducto : Int) -> Result {
        
        let result = Result()
        
        var statement : OpaquePointer! = nil
        let query = #"SELECT IdProducto, Producto.Nombre, PrecioUnitario, Stock, Descripcion, Producto.Imagen, Producto.IdDepartamento, Departamento.Nombre, Producto.IdProveedor, Proveedor.Nombre, Proveedor.Telefono, Departamento.IdArea, Area.Nombre FROM Producto INNER JOIN Departamento on Departamento.IdDepartamento = Producto.IdDepartamento INNER JOIN Proveedor on Proveedor.IdProveedor = Producto.IdProveedor INNER JOIN Area on Departamento.IdArea = Area.IdArea WHERE IdProducto = \#(IdProducto)"#
        let conexion = DBManager.init()
        
        do{
            
            if sqlite3_prepare(conexion.db, query, -1, &statement, nil) == SQLITE_OK {
                
                if (sqlite3_step(statement) == SQLITE_ROW){
                    
                    let producto = Producto()
                    
                    producto.IdProducto = Int(sqlite3_column_int(statement, 0))
                    producto.Nombre = String(cString: sqlite3_column_text(statement, 1))
                    producto.PrecioUnitario = Double(sqlite3_column_double(statement, 2))
                    producto.Stock = Int(sqlite3_column_int(statement, 3))
                    producto.Descripcion = String(cString: sqlite3_column_text(statement, 4))
                    if sqlite3_column_text(statement, 5) != nil {
                        producto.Imagen = String(cString: sqlite3_column_text(statement, 5))
                    }else{
                        producto.Imagen = ""
                    }
                    producto.departamento.IdDepartamento = Int(sqlite3_column_int(statement, 6))
                    producto.departamento.Nombre = String(cString: sqlite3_column_text(statement, 7))
                    producto.proveedor.IdProveedor = Int(sqlite3_column_int(statement, 8))
                    producto.proveedor.Nombre = String(cString: sqlite3_column_text(statement, 9))
                    producto.proveedor.Telefono = String(cString: sqlite3_column_text(statement, 10))
                    producto.departamento.area.IdArea = Int(sqlite3_column_int(statement, 11))
                    producto.departamento.area.Nombre = String(cString: sqlite3_column_text(statement, 12))
                    
                    result.Object = producto
                    
                   
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
    
    
    static func GetByDepartamento(_ IdDepartamento : Int) -> Result {
        
        let result = Result()
        
        var statement : OpaquePointer! = nil
        let query = #"SELECT IdProducto, Producto.Nombre, PrecioUnitario, Stock, Descripcion, Producto.Imagen, Producto.IdDepartamento, Departamento.Nombre, Producto.IdProveedor, Proveedor.Nombre, Proveedor.Telefono, Departamento.IdArea, Area.Nombre FROM Producto INNER JOIN Departamento on Departamento.IdDepartamento = Producto.IdDepartamento INNER JOIN Proveedor on Proveedor.IdProveedor = Producto.IdProveedor INNER JOIN Area on Departamento.IdArea = Area.IdArea WHERE Producto.IdDepartamento = \#(IdDepartamento)"#
        let conexion = DBManager.init()
        
        do{
            
            if sqlite3_prepare(conexion.db, query, -1, &statement, nil) == SQLITE_OK {
                
                result.Objects = [Any]()
                
                while (sqlite3_step(statement) == SQLITE_ROW){
                    
                    let producto = Producto()
                    
                    producto.IdProducto = Int(sqlite3_column_int(statement, 0))
                    producto.Nombre = String(cString: sqlite3_column_text(statement, 1))
                    producto.PrecioUnitario = Double(sqlite3_column_double(statement, 2))
                    producto.Stock = Int(sqlite3_column_int(statement, 3))
                    producto.Descripcion = String(cString: sqlite3_column_text(statement, 4))
                    producto.Imagen = String(cString: sqlite3_column_text(statement, 5))
                    producto.departamento.IdDepartamento = Int(sqlite3_column_int(statement, 6))
                    producto.departamento.Nombre = String(cString: sqlite3_column_text(statement, 7))
                    producto.proveedor.IdProveedor = Int(sqlite3_column_int(statement, 8))
                    producto.proveedor.Nombre = String(cString: sqlite3_column_text(statement, 9))
                    producto.proveedor.Telefono = String(cString: sqlite3_column_text(statement, 10))
                    producto.departamento.area.IdArea = Int(sqlite3_column_int(statement, 11))
                    producto.departamento.area.Nombre = String(cString: sqlite3_column_text(statement, 12))
                    
                    result.Objects?.append(producto)
                   
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
    
    
    
}
