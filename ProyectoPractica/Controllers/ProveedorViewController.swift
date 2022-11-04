//
//  ProveedorViewController.swift
//  SGalindoEcommerce
//


import UIKit

class ProveedorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var idProveedor : Int = 0
    var result = Result()
    
    let imagePicker = UIImagePickerController()
    
    
    @IBOutlet weak var imagenProveedor: UIImageView!
    
    @IBOutlet weak var textTelefono: UITextField!
    @IBOutlet weak var textNombre: UITextField!
    
   
    @IBOutlet weak var proveedorButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Validar()
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    

    @IBAction func addImagen(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
            
        } else {
            print("No se pudo acceder a la libreria de fotos")
        }
    
    }
    
     @IBAction func proveedorActButton(_ sender: UIButton) {
         
         let proveedor = Proveedor()
         
         proveedor.Nombre = textNombre.text!
         proveedor.Telefono = textTelefono.text!
         if imagenProveedor.restorationIdentifier == "UsuarioAdd"{
             proveedor.Imagen = ""
         }else{
             let imagen : UIImage = imagenProveedor.image!
             let imagenData : NSData = imagen.pngData()! as NSData
             proveedor.Imagen = imagenData.base64EncodedString(options:   .lineLength64Characters)
         }
         
         let textbutton = sender.currentTitle
         if  textbutton == "Agregar" {
             
             result = Proveedor.Add(proveedor)
             if result.Correct == true {
                 let dialogMessage = UIAlertController(title: "Operacion exitosa", message: "El proveedor se agrego con exito", preferredStyle: .alert)
                 let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                 })
                 dialogMessage.addAction(ok)
                 self.present(dialogMessage, animated: true, completion: nil)
             }else{
                 let dialogMessage = UIAlertController(title: "Ocurrio un error", message: "No se puedo agregar al proveedor", preferredStyle: .alert)
                 let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                 })
                 dialogMessage.addAction(ok)
                 self.present(dialogMessage, animated: true, completion: nil)
             }
         
                     
         }else if textbutton == "Actualizar"{
             
             proveedor.IdProveedor = idProveedor
             let result : Result = Proveedor.Update(proveedor)
             if result.Correct == true {
                 let dialogMessage = UIAlertController(title: "Operacion exitosa", message: "El proveedor se actualizo con exito", preferredStyle: .alert)
                 let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                 })
                 dialogMessage.addAction(ok)
                 self.present(dialogMessage, animated: true, completion: nil)
             }else{
                 let dialogMessage = UIAlertController(title: "Ocurrio un error", message: "No se puedo actualizar al proveedor", preferredStyle: .alert)
                 let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                 })
                 dialogMessage.addAction(ok)
                 self.present(dialogMessage, animated: true, completion: nil)
             }
                     
         }
         
         
         
     }
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

    func Validar(){
        
        if self.idProveedor != 0 {
            let result : Result = Proveedor.GetbyId(idProveedor)
            if result.Correct {
                
                let proveedor = result.Object as! Proveedor
                
                textNombre.text = proveedor.Nombre
                textTelefono.text = proveedor.Telefono
                if proveedor.Imagen == ""{
                    imagenProveedor.image = UIImage(named: "UsuarioAdd")!
                }else{
                    let imagen = Data(base64Encoded: proveedor.Imagen, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
                    imagenProveedor.image = UIImage(data: imagen)!
                }
                proveedorButton.setTitle("Actualizar", for: .normal)
                proveedorButton.backgroundColor = .yellow
                
            }
            
        }else{
            
            imagenProveedor.image = UIImage(named: "UsuarioAdd")
            
            proveedorButton.setTitle("Agregar", for: .normal)
            proveedorButton.backgroundColor = .green
            
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            imagenProveedor.image = image //Obtiene la informacion de la foto y la almacena
        }
        imagePicker.dismiss(animated: true, completion: nil) //Cerrar la camara


    }
}
