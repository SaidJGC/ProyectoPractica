//
//  ProveedprTableViewCell.swift
//  SGalindoEcommerce
//


import UIKit
import SwipeCellKit

class ProveedprTableViewCell: SwipeTableViewCell {

    
    @IBOutlet weak var imagenProveedor: UIImageView!
    
    @IBOutlet weak var labelNombre: UILabel!
    
    @IBOutlet weak var labelTelefono: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
