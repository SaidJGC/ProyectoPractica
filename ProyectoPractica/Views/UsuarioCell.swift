//
//  UsuarioCell.swift
//  SGalindoEcommerce
//


import UIKit
import SwipeCellKit

class UsuarioCell: SwipeTableViewCell {

    
    @IBOutlet weak var imagenUsuario: UIImageView!
    
    @IBOutlet weak var ApellidoMaterno: UILabel!
    @IBOutlet weak var ApellidoPaterno: UILabel!
    @IBOutlet weak var Nombre: UILabel!
    
    @IBOutlet weak var Email: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
