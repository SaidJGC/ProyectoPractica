//
//  ProveedorTableViewController.swift
//  SGalindoEcommerce
//


import UIKit
import SwipeCellKit

class ProveedorTableViewController: UITableViewController {
    
    var result = Result()
    var proveedor = Proveedor()
    var proveedores : [Proveedor] = []
    
    
    var isLoadingViewController = false

    override func viewDidLoad() {
        super.viewDidLoad()
        isLoadingViewController = true
             viewLoadSetup()
        
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
                     UINib(nibName: "ProveedprTableViewCell", bundle: nil),
                     forCellReuseIdentifier: "ProveedprTableViewCell")
         }
    
    func LoadData(){
        
        do{
            result = try! Proveedor.GetAll()
            if result.Correct{
                proveedores = result.Objects as! [Proveedor]
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
        return proveedores.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProveedprTableViewCell", for: indexPath) as! ProveedprTableViewCell

        cell.delegate = self
        let proveedor : Proveedor = proveedores[indexPath.row]
        cell.labelNombre.text = proveedor.Nombre
        cell.labelTelefono.text = proveedor.Telefono
        if proveedor.Imagen == ""{
            cell.imagenProveedor.image = UIImage(named: "ImagenProducto")
        }else{
            let imagen = Data(base64Encoded: proveedor.Imagen, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
            cell.imagenProveedor.image = UIImage(data: imagen)!
        }
        
        return cell
    }
    
}


extension ProveedorTableViewController : SwipeTableViewCellDelegate{
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .right {
            
            let deleteAction = SwipeAction(style: .destructive, title: "Eliminar") { [self] action, indexPath in
                
                let proveedor : Proveedor = self.proveedores[indexPath.row]
                self.result = Proveedor.Delete(proveedor.IdProveedor)
                if result.Correct == true {
                    let dialogMessage = UIAlertController(title: "Operacion exitosa", message: "El proveedor se elimino con exito", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    })
                    dialogMessage.addAction(ok)
                    self.present(dialogMessage, animated: true, completion: nil)
                    
                    
                }else{
                    let dialogMessage = UIAlertController(title: "Ocurrio un error", message: "No se pudo eliminar al proveedor", preferredStyle: .alert)
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
                
                self.proveedor = self.proveedores[indexPath.row] 
                self.performSegue(withIdentifier: "IdProveedor", sender: self)
            }
            
            return [updateAction]
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "IdProveedor" {
            let proveedorSend = segue.destination as? ProveedorViewController
            
            proveedorSend?.idProveedor = self.proveedor.IdProveedor
            
            
        }
    }
}
