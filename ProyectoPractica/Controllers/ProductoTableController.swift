//
//  ProductoTableController.swift
//  SGalindoEcommerce
//


import UIKit
import SwipeCellKit

class ProductoTableController: UITableViewController {
    
    
    var result = Result()
    var productos : [Producto] = []
    var producto = Producto()
    
    var isLoadingViewController = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           if isLoadingViewController {
                    isLoadingViewController = false
                } else {
                    viewLoadSetup()
                 }
           
        }


         func viewLoadSetup(){
             LoadData()
             
             tableView.register(
                     UINib(nibName: "ProductoCell", bundle: nil),
                     forCellReuseIdentifier: "ProductoCell")
         }
    
    func LoadData(){
        
        do{
            result = try! Producto.GetAll()
            if result.Correct{
                productos = result.Objects as! [Producto]
                tableView.reloadData()
                
            }
        }catch {
            print("Ocurrio un error")
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return productos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
             withIdentifier:"ProductoCell", for: indexPath) as! ProductoCell
 
        
        cell.delegate = self
        let producto : Producto = productos[indexPath.row]
        
        cell.textNombreProducto.text = producto.Nombre
        cell.textPrecioUnitario.text = String(producto.PrecioUnitario)
        cell.textDescripcion.text = producto.Descripcion
        cell.textDepartamento.text = producto.departamento.Nombre
        cell.textProveedor.text = producto.proveedor.Nombre
        if producto.Imagen == ""{
            cell.imagenProducto.image = UIImage(named: "ImagenProducto")!
        }else{
            let imagen = Data(base64Encoded: producto.Imagen, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
            cell.imagenProducto.image = UIImage(data: imagen)!
        }
        return cell
    }
    

}

extension ProductoTableController : SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .right {
            
            let deleteAction = SwipeAction(style: .destructive, title: "Eliminar") { [self] action, indexPath in
                
                let producto : Producto = self.productos[indexPath.row]
                self.result = Producto.Delete(producto.IdProducto)
                if result.Correct == true {
                    let dialogMessage = UIAlertController(title: "Operacion exitosa", message: "El producto se elimino con exito", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    })
                    dialogMessage.addAction(ok)
                    self.present(dialogMessage, animated: true, completion: nil)
                }else{
                    let dialogMessage = UIAlertController(title: "Ocurrio un error", message: "No se puedo eliminar el producto", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    })
                    dialogMessage.addAction(ok)
                    self.present(dialogMessage, animated: true, completion: nil)
                }
                self.LoadData()
            }
            
            return [deleteAction]
        }else {
            
            let updateAction = SwipeAction(style: .default, title: "Actualizar") { action, indexPath in
                
                self.producto = self.productos[indexPath.row]
                self.performSegue(withIdentifier: "Update", sender: self)
            }
            
            return [updateAction]
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Update" {
            let productoSend = segue.destination as? ProductoController
            productoSend?.idProducto = self.producto.IdProducto
            
            
        }
    }
    
}
