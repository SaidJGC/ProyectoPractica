//
//  ViewController.swift
//  SGalindoEcommerce
//


import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
        
        var result = Result()
        
        let imagePicker = UIImagePickerController()
        
        
        @IBOutlet weak var usuarioImagen: UIImageView!
        
        @IBOutlet weak var labelNombre: UITextField!
        @IBOutlet weak var labelApellidoPaterno: UITextField!
        @IBOutlet weak var labelApellidoMaterno: UITextField!
        @IBOutlet weak var labelEmail: UITextField!
        
        @IBOutlet weak var textPassword: UITextField!
        var IdUsuario : Int = 0
        
        @IBOutlet weak var opButton: UIButton!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            imagePicker.delegate = self
            print(IdUsuario)
            Validar()
            
            //var con = Conexion.init()
            //var db = DBManager()
            // Do any additional setup after loading the view.
        }
        
        
        
        @IBAction func funcButton(_ sender: UIButton) {
            
            let usuario = Usuario()
            
            usuario.Nombre = labelNombre.text!
            usuario.ApellidoPaterno = labelApellidoPaterno.text!
            usuario.ApellidoMaterno = labelApellidoMaterno.text!
            usuario.Email = labelEmail.text!
            usuario.Password = textPassword.text!
            if usuarioImagen.restorationIdentifier == "UsuarioAdd"{
                usuario.Imagen = ""
            }else{
                let imagen : UIImage = usuarioImagen.image!
                let imagenData : NSData = imagen.pngData()! as NSData
                usuario.Imagen = imagenData.base64EncodedString(options:   .lineLength64Characters)
            }
            
            let textbutton = sender.currentTitle
            if  textbutton == "Agregar" {
                
                let result : Result = Usuario.Add(usuario)
                if result.Correct == true {
                    
                    let dialogMessage = UIAlertController(title: "Operacion Exitosa", message: "Usuario agregado con exito", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    })
                    dialogMessage.addAction(ok)
                    self.present(dialogMessage, animated: true, completion: nil)
                    
                    
                }
                else{
                    
                    let dialogMessage = UIAlertController(title: "Ocurrio un error", message: "No se pudo agregar al usuario", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    })
                    dialogMessage.addAction(ok)
                    self.present(dialogMessage, animated: true, completion: nil)
                    
                }
                
                
            }else if textbutton == "Actualizar"{
                
                usuario.IdUsuario = IdUsuario
                let result : Result = Usuario.Update(usuario)
                if result.Correct == true {
                    
                    let dialogMessage = UIAlertController(title: "Operacion Exitosa", message: "Usuario actualizado con exito", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    })
                    dialogMessage.addAction(ok)
                    self.present(dialogMessage, animated: true, completion: nil)
                    
                    
                }
                else{
                    
                    let dialogMessage = UIAlertController(title: "Ocurrio un error", message: "No se pudo actualizar al usuario", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    })
                    dialogMessage.addAction(ok)
                    self.present(dialogMessage, animated: true, completion: nil)
                    
                }
                
                
            }
        }
        
        
        @IBAction func imagenUsuario(_ sender: Any) {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                imagePicker.allowsEditing = true
                
                self.present(imagePicker, animated: true, completion: nil)
                
            } else {
                print("No se pudo acceder a la libreria de fotos")
            }
        }
        
        func Validar (){
            if self.IdUsuario != 0 {
                let result: Result = Usuario.GetById(IdUsuario)
                if result.Correct {
                    let usuario = result.Object as! Usuario
                    
                    labelNombre.text = usuario.Nombre
                    labelApellidoPaterno.text = usuario.ApellidoPaterno
                    labelApellidoMaterno.text = usuario.ApellidoMaterno
                    labelEmail.text = usuario.Email
                    textPassword.text = usuario.Password
                    let imagen = Data(base64Encoded: usuario.Imagen, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
                    usuarioImagen.image = UIImage(data: imagen)
                    
                    opButton.setTitle("Actualizar", for: .normal)
                    opButton.backgroundColor = .yellow
                    
                }
                else
                {
                    print("Ocurrio un error")
                }
                
            }else{
                
                usuarioImagen.image = UIImage(named: "UsuarioAdd")
                //usuarioImagen.restorationIdentifier = "UsuarioAdd"
                opButton.setTitle("Agregar", for: .normal)
                opButton.backgroundColor = .green
            }
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                usuarioImagen.image = image //Obtiene la informacion de la foto y la almacena
            }
            imagePicker.dismiss(animated: true, completion: nil) //Cerrar la camara
            
            
        }
    }

