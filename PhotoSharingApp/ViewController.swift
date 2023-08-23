//
//  ViewController.swift
//  PhotoSharingApp
//
//  Created by Göknur Bulut on 6.08.2023.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var sifreTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func girisYapTiklandi(_ sender: Any) {
        
        if emailTextField.text != "" && sifreTextField.text != "" {
            // giriş yapma işlemi yap
            
            Auth.auth().signIn(withEmail: emailTextField.text! , password: sifreTextField.text!){
                (authdataresult, error) in
                if error != nil{
                    self.hataMesaji(titleInput: "Hata!", messageInput: error?.localizedDescription ?? "Hata ALdınız, Lütfen Tekrar  Deneyiniz")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else {
            hataMesaji(titleInput: "Hata!", messageInput: "Email Ve Parola Giriniz!")
        }
        
        
    }
    
    
    
    @IBAction func kayıtOlTiklandi(_ sender: Any) {
        
        if emailTextField.text != "" && sifreTextField.text != "" {
            // kayıt olma işlemi yap
            Auth.auth().createUser(withEmail: emailTextField.text!, password: sifreTextField.text!) { authdataresult , error in
                if error != nil {
                    self.hataMesaji(titleInput: "Hata", messageInput: error?.localizedDescription ?? " Hata Aldınız, Tekrar Deneyiniz ")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        }else {
            hataMesaji(titleInput: "Hata!", messageInput: "Email Ve Parola Giriniz!")
            
        }
        
        
    }
    
    func hataMesaji(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert
        )
        let okButton = UIAlertAction(title: "OK", style: .default , handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
                                      
        
        
    }
    
}

