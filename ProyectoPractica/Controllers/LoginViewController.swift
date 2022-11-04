//
//  LoginViewController.swift
//  SGalindoEcommerce
//

import UIKit

var result = Result()
var usuario = Usuario()

class LoginViewController: UIViewController {
    
    
    var email : String = ""
    var password :String = ""
    
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var textEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func actionLogin(_ sender: UIButton) {
        
        email = textEmail.text!
        password = textPassword.text!
        Validar()
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
    
    func Login(){
        
        do{
            
            
            let loginManager = FirebaseAuthManager()
            guard let email = textEmail.text, let password = textPassword.text else {return}
            loginManager.signIn(email: email, pass: password) {[weak self] (success) in
                guard let `self` = self else { return }
                var message: String = ""
                if (success) {
                    self.performSegue(withIdentifier: "Login", sender: self)
                } else {
                    
                }
                let dialogMessage = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                })
                dialogMessage.addAction(ok)
                self.present(dialogMessage, animated: true, completion: nil)
            }
            //            result = try! Usuario.GetByEmail(email)
            //            if result.Correct == true {
            //                let usuario = result.Object as! Usuario
            //
            //                if usuario.Password == password {
            //                    self.performSegue(withIdentifier: "Login", sender: self)
            //                }else{
            //                    displayAlertPassword()
            //                }
            //
            //            }else{
            //                displayAlertEmail()
            //            }
        }catch let error  {
            print(error.localizedDescription)
            let dialogMessage = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
        }
        
    }
    
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 22.0/255.0, green: 36.0/255.0, blue: 71.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 31.0/255.0, green: 64.0/255.0, blue: 110.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Login" {
            
        }
    }
    
    func displayAlertEmail() {
        // Declare Alert message
        let dialogMessage = UIAlertController(title: "Campos vacios", message: "Por favor escribe datos en los campos", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            //self.deleteRecord()
        })
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    func displayAlertPassword() {
        // Declare Alert message
        let dialogMessage = UIAlertController(title: "Datos Incorrectos", message: "La contraseña no coincide", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            //self.deleteRecord()
        })
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    func Validar() {
    
        if email == "", password == ""{
            displayAlertEmail()
        }else {
            Login()
            
        }
    }
    
}
