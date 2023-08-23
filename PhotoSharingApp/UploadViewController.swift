//
//  UploadViewController.swift
//  PhotoSharingApp
//
//  Created by Göknur Bulut on 14.08.2023.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var yorumTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
//        kullanıcı üstüne tıklayınca işlem yapabilsin.
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        
    }
    
    @objc func gorselSec() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController,animated: true, completion: nil)
        
        
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func uploadButtonTiklandi(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
//        child sayesinde olduğumuz klasörün daha altına iniyoruz.
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            
//            imageviewı bytlarla dataya çeviriyoruz.
        
            
            let uuid = UUID().uuidString
            
        let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data ,metadata: nil) { storagemetadata, error in
                if error != nil {
                    
                    self.hataMesajiGoster(title: "HATA!", message: error?.localizedDescription ?? "Hata ALdınız, Lütfen Tekrar Deneyiniz!")
                    
                }else{
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageURL = url?.absoluteString
                            
                            if let imageURL = imageURL {
                                
                                let firestoreDatabase = Firestore.firestore()
                                
                                
                                let firestorePost = ["gorselurl" : imageURL, "yorum" : self.yorumTextField.text! ,"email" : Auth.auth().currentUser!.email, "tarih" : FieldValue.serverTimestamp()]
//                                manuel collection oluşturma
                                
                                
                                firestoreDatabase.collection("Post").addDocument(data: firestorePost) {
                                    (error) in
                                    if error != nil {
                                        
                                        self.hataMesajiGoster(title: "Hata", message: error?.localizedDescription ?? "Hata Aldınız, Tekrar Deneyiniz!")
                                    }else{
                                        
                                        self.imageView.image = UIImage(named: "choose")
                                        self.yorumTextField.text = ""
                                        self.tabBarController?.selectedIndex = 0
//                                        alttaki feed upload vs hepsinin index numarsı var ben feede dönsün istediğimden 0 veriyorum.
                                    }
                                }
                                
                                
                                
                                
                                
                                
                            }
                           
                            
                           
                        }
                    }
                }
            }
        }
    

    
}
    
    func hataMesajiGoster(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
        
    }
