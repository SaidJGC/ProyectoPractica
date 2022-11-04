//
//  TableViewController.swift
//  SGalindoEcommerce
//


import UIKit
import SwipeCellKit

class TableViewController: UITableViewController {
    
    var result = Result()
    var usuarios : [Usuario] = []
    var usuario = Usuario()

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
                     UINib(nibName: "UsuarioCell", bundle: nil),
                     forCellReuseIdentifier: "UsuarioCell")
         }
    // MARK: - Table view data source
    
    func LoadData(){
        
        do{
            result = try! Usuario.GetAll()
            if result.Correct{
                usuarios = result.Objects as! [Usuario]
                tableView.reloadData()
                
            }
        }catch {
            print("Ocurrio un error")
        }

    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usuarios.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
             withIdentifier:"UsuarioCell", for: indexPath) as! UsuarioCell
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Celdatester", for: indexPath)
        cell.delegate = self
        let usuario : Usuario = usuarios[indexPath.row]
        
        
        cell.Nombre.text = usuario.Nombre
        cell.ApellidoPaterno.text = usuario.ApellidoPaterno
        cell.ApellidoMaterno.text = usuario.ApellidoMaterno
        cell.Email.text = usuario.Email
        if usuario.Imagen == ""{
            cell.imagenUsuario.image = UIImage(named: "UsuarioImage")!
        }else{
            let imagen = Data(base64Encoded: usuario.Imagen, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
            cell.imagenUsuario.image = UIImage(data: imagen)!
        }
        
        // Configure the cell...

        return cell
    }
    

}

extension TableViewController : SwipeTableViewCellDelegate{
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .right {
            
            let deleteAction = SwipeAction(style: .destructive, title: "Eliminar") { action, indexPath in
                
                let usuario : Usuario = self.usuarios[indexPath.row]
                Usuario.Delete(usuario.IdUsuario)
                self.LoadData()
            }
            
            return [deleteAction]
        }else {
            
            let updateAction = SwipeAction(style: .default, title: "Actualizar") { action, indexPath in
                
                self.usuario = self.usuarios[indexPath.row]
                self.performSegue(withIdentifier: "Update", sender: self)
            }
            
            return [updateAction]
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Update" {
            let usuarioSend = segue.destination as? ViewController
            
            usuarioSend?.IdUsuario = self.usuario.IdUsuario
            
        }
    }
}
