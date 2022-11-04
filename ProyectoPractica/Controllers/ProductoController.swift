//
//  ProductoController.swift
//  SGalindoEcommerce
//


import UIKit
import iOSDropDown

class ProductoController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var departamento = Departamento()
    var departamentos : [Departamento]?
    var proveedor = Proveedor()
    var proveedores : [Proveedor]?
    var arrayNombresD : [String] = []
    var arrayIdsD : [Int] = []
    var arrayNombresP : [String] = []
    var arrayIdsP : [Int] = []
    let imagePicker = UIImagePickerController()
    var idProducto : Int = 0
    var idDepartamento : Int = 0
    var idProveedor : Int = 0
    
    @IBOutlet weak var loadImagen: UIImageView!
    
    @IBOutlet weak var textNombre: UITextField!
    
    @IBOutlet weak var textDescripcion: UITextField!
    
    @IBOutlet weak var textPrecioUnitario: UITextField!
    
    @IBOutlet weak var textDepartamento: UITextField!
    
    @IBOutlet weak var textProveedor: UITextField!
    
    @IBOutlet weak var textStock: UITextField!
    
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var pickImage: UIButton!
    
    @IBOutlet weak var dropDownDepartamento : DropDown!
    
    @IBOutlet weak var dropDownProveedor : DropDown!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Validar()
        print(idProducto)
        imagePicker.delegate = self
        LoadData()
        LoadDataProveedor()
        self.dropDownDepartamento.optionArray = arrayNombresD
        self.dropDownDepartamento.optionIds = arrayIdsD
        
        self.dropDownProveedor.optionArray = arrayNombresP
        self.dropDownProveedor.optionIds = arrayIdsP
        
        dropDownProveedor.didSelect { selectedText, index, id in
            self.idProveedor = id }
        
        dropDownDepartamento.didSelect { selectedText, index, id in
            self.idDepartamento = id }
        
    }
    
    @IBAction func productoButton(_ sender: UIButton) {
        
        
        let producto = Producto()
        
        producto.Nombre = textNombre.text!
        producto.Descripcion = textDescripcion.text!
        producto.PrecioUnitario = Double(textPrecioUnitario.text!)!
        producto.Stock = Int(textStock.text!)!
        producto.departamento.IdDepartamento = idDepartamento
        producto.proveedor.IdProveedor = idProveedor
        if loadImagen.restorationIdentifier == "ProductoAdd"{
            producto.Imagen = ""
        }else{
            let imagen : UIImage = loadImagen.image!
            let imagenData : NSData = imagen.pngData()! as NSData
            producto.Imagen = imagenData.base64EncodedString(options:   .lineLength64Characters)
        }
        
        //Int(textProveedor.text!)!
        
        let textbutton = sender.currentTitle
        if  textbutton == "Agregar" {
            
            let result: Result = Producto.Add(producto)
            if result.Correct == true {
                
                let dialogMessage = UIAlertController(title: "Operacion Exitosa", message: "Producto agregado con exito", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                })
                dialogMessage.addAction(ok)
                self.present(dialogMessage, animated: true, completion: nil)
                
                
            }
            else{
                
                let dialogMessage = UIAlertController(title: "Ocurrio un error", message: "No se pudo agregar el producto", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                })
                dialogMessage.addAction(ok)
                self.present(dialogMessage, animated: true, completion: nil)
                
            }
        
        
                    
        }else if textbutton == "Actualizar"{
            
            producto.IdProducto = idProducto
            Producto.Update(producto)
                    
        }
    }
    
    
    @IBAction func pickerImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true

            self.present(imagePicker, animated: true, completion: nil)
            
          } else {
            print("No se pudo acceder a la libreria de fotos")
          }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                loadImagen.image = image //Obtiene la informacion de la foto y la almacena
            }
            imagePicker.dismiss(animated: true, completion: nil) //Cerrar la camara
            
            
        }
    
    func Validar (){
        if self.idProducto != 0 {
            let result: Result = Producto.GetById(idProducto)
                if result.Correct {
                    let producto = result.Object as! Producto
                   
                    textNombre.text = producto.Nombre
                    textDescripcion.text = producto.Descripcion
                    textStock.text = String(producto.Stock)
                    textPrecioUnitario.text = String(producto.PrecioUnitario)
                    textDepartamento.text = String(producto.departamento.Nombre)
                    textProveedor.text = String(producto.proveedor.Nombre)
                    let imagen = Data(base64Encoded: producto.Imagen, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
                    loadImagen.image = UIImage(data: imagen)
                    
                    actionButton.setTitle("Actualizar", for: .normal)
                    actionButton.backgroundColor = .yellow
                    
                }
                else
                {
                    print("Ocurrio un error")
                }
 
            }else{
                
                
                loadImagen.image = UIImage(named: "ProductoAdd")
                loadImagen.restorationIdentifier = "ProductoAdd"
                actionButton.setTitle("Agregar", for: .normal)
                actionButton.backgroundColor = .green
            }
        }
    
    
    
    
    
    func displayAlert() {
            // Declare Alert message
            let dialogMessage = UIAlertController(title: "Operacion Exitosas", message: "Producto agregado con exito", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
                //self.deleteRecord()
            })
            
            // Create Cancel button with action handlder
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                print("Cancel button tapped")
            }
            
            //Add OK and Cancel button to dialog message
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            
            // Present dialog message to user
            self.present(dialogMessage, animated: true, completion: nil)
            
        }
    
    
    func LoadData(){
        
        
        let resultDepartamento : Result = try! Departamento.GetAll()
        if resultDepartamento.Correct {
            departamentos = resultDepartamento.Objects as? [Departamento]
            for  departamento in departamentos! {
                
                arrayNombresD.append(departamento.Nombre)
                arrayIdsD.append(departamento.IdDepartamento)
                
            }
        }
        else {
            print("error al cargar los datos")
        }
        
    }
    
    func LoadDataProveedor(){
        
        let resultProveedor : Result = try! Proveedor.GetAll()
        if resultProveedor.Correct {
            proveedores = resultProveedor.Objects as? [Proveedor]
            for proveedor in proveedores! {
                
                arrayNombresP.append(proveedor.Nombre)
                arrayIdsP.append(proveedor.IdProveedor)
                
            }
        }
        else {
            print("error al cargar los datos")
        }
    }
    
    }


