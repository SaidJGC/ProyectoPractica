//
//  UsuarioGUController.swift
//  SGalindoEcommerce
//


import UIKit

class UsuarioGUController: UIViewController {

    
    @IBOutlet weak var Nombre: UITextField!
    
    @IBOutlet weak var ApellidoPaterno: UITextField!
    
    
    @IBOutlet weak var ApellidoMaterno: UITextField!
    
    @IBOutlet weak var Email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func updateButton(_ sender: UIButton) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
