//
//  TestCollectionViewController.swift
//  SGalindoEcommerce
//

import UIKit
import CoreData

private let reuseIdentifier = "ProductoCollectionViewCell"

class ProductoCollectionViewController: UICollectionViewController {
    
    var result = Result()
    var productos : [Producto] = []
    var producto = Producto()
    var idDepartamento : Int = 0
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
             Validar()
             // Register cell classes
             self.collectionView!.register(UINib(nibName: "ProductoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
             //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    
    func saveData() {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}

        let context = appDelegate.persistentContainer.viewContext

        let userEntity = NSEntityDescription.entity(forEntityName: "Carrito", in: context)!

        let carrito = NSManagedObject(entity: userEntity, insertInto: context)

        carrito.setValue(producto.IdProducto, forKey: "idproducto")
        carrito.setValue(1, forKey: "cantidad")


        do{
            try context.save()
        }catch let error as NSError {

            print("could not save . \(error), \(error.userInfo)")
        }

        
    }
    
    func Validar(){
        
        if idDepartamento != 0 {
            result = try! Producto.GetByDepartamento(idDepartamento)
            if result.Correct == true {
                
                if result.Objects!.count != 0 {
                    productos = result.Objects as! [Producto]
                    collectionView.reloadData()
                }else{
                    
                    let dialogMessage = UIAlertController(title: "No se encontraron registros", message: "El departamento solicitado no contiene productos", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    })
                    dialogMessage.addAction(ok)
                    self.present(dialogMessage, animated: true, completion: nil)
                }
                
            }else{
                result.ErrorMessage = "Error al consultar los productos"
            }
        }else{
            result = try! Producto.GetAll()
            if result.Correct{
                productos = result.Objects as! [Producto]
                collectionView.reloadData()
            }else{
                result.ErrorMessage = "Error al consultar los productos"
            }
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return productos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductoCollectionViewCell
        // Configure the cell
        producto = productos[indexPath.row]
        cell.labelNombre.text = producto.Nombre
        cell.labelPrecioUnitario.text = "$\(String(producto.PrecioUnitario))"
        if producto.Imagen == ""{
            cell.productoImagen.image = UIImage(named: "ImagenProducto")!
        }else{
            let imagen = Data(base64Encoded: producto.Imagen, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
            cell.productoImagen.image = UIImage(data: imagen)!
        }
        
        return cell
        
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)    {

        self.producto = self.productos[indexPath.row]
        self.performSegue(withIdentifier: "DetalleProducto", sender: self)
        
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "DetalleProducto" {
                let productoSend = segue.destination as? DetalleProductoViewController
                productoSend?.idProducto = self.producto.IdProducto
                
                
            }
        }
}
