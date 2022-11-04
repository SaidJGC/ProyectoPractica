//
//  ProductoCell.swift
//  SGalindoEcommerce
//


import UIKit
import SwipeCellKit

class ProductoCell: SwipeTableViewCell {

    @IBOutlet weak var textProveedor: UILabel!
    @IBOutlet weak var textDepartamento: UILabel!
    @IBOutlet weak var textDescripcion: UILabel!
    @IBOutlet weak var textPrecioUnitario: UILabel!
    @IBOutlet weak var textNombreProducto: UILabel!
    
    @IBOutlet weak var imagenProducto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
