//
//  DetalleProductoViewController.swift
//  SGalindoEcommerce
//


import UIKit

class DetalleProductoViewController: UIViewController {
    
    
    
    var idProducto : Int = 0
    
    @IBOutlet weak var imagenProducto: UIImageView!
    
    @IBOutlet weak var labelNombreProducto: UILabel!
    
    @IBOutlet weak var labelPrecio: UILabel!
    
    @IBOutlet weak var labelDescripcion: UILabel!
    
    @IBOutlet weak var labelNombreProveedor: UILabel!
    
    @IBOutlet weak var labelTelefono: UILabel!
    
    @IBOutlet weak var labelNombreDepartamento: UILabel!
    
    @IBOutlet weak var labelNombreArea: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoadDataProducto()
        print(idProducto)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func LoadDataProducto(){
        if self.idProducto != 0 {
            let result : Result = Producto.GetById(idProducto)
            if result.Correct == true {
                
                let producto = result.Object as! Producto
                
                labelNombreProducto.text = producto.Nombre
                labelPrecio.text = "$\(String(producto.PrecioUnitario))"
                labelDescripcion.text = producto.Descripcion
                labelNombreProveedor.text = producto.proveedor.Nombre
                labelTelefono.text = producto.proveedor.Telefono
                labelNombreDepartamento.text = producto.departamento.Nombre
                labelNombreArea.text = producto.departamento.area.Nombre
                if producto.Imagen == ""{
                    imagenProducto.image = UIImage(named: "ImagenProducto")!
                }else{
                    let imagen = Data(base64Encoded: producto.Imagen, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
                    imagenProducto.image = UIImage(data: imagen)!
                }
                
            }
            
            else{
                
                print("Error al cargar la informacion del producto")
            }
            
        }else{
            print("No se encontro informacion con el Id: \(idProducto)")
        }
        
    }
    
}
