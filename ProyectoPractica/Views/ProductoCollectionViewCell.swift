//
//  ProductoCollectionViewCell.swift
//  SGalindoEcommerce
//


import UIKit
import CoreData

class ProductoCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var labelPrecioUnitario: UILabel!
    @IBOutlet weak var labelNombre: UILabel!
    @IBOutlet weak var productoImagen: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addCart(_ sender: UIButton) {
        
//        var producto = NSEntityDescription.insertNewObjectForEntityForName("Person",
//        inManagedObjectContext: self.managedObjectContext!)
//        producto.name = "Mary"
//        producto.age = Float(arc4random() % 100)
    }
}
