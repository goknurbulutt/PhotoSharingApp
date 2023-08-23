//
//  FeedViewController.swift
//  PhotoSharingApp
//
//  Created by Göknur Bulut on 14.08.2023.
//

import UIKit
import Firebase
import SDWebImage
class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var emailDizisi = [String]()
    var yorumDizisi = [String]()
    var gorselDizisi = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
    
    
    tableView.delegate = self
    tableView.dataSource = self
        
        firebaseVerileriAl()
        
    }
    

    func firebaseVerileriAl() {
        
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Post").order(by: "tarih", descending: true)
            .addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            }else{
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
//                      let documentId = document.documentID
//                        print(documentId)
                        if let gorselUrl = document.get("gorselUrl") as? String {
                            self.gorselDizisi.append(gorselUrl)
                        }
                        
                        if let email = document.get("email") as? String {
                            self.emailDizisi.append(email)
                        }
                        
                        if let yorum = document.get("yorum") as? String {
                            self.yorumDizisi.append(yorum)
                        }
                        
                        self.tableView.reloadData()
                        
                    }
                }
            }
            
        }
        
    }
    
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailDizisi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.emailText.text = emailDizisi[indexPath.row]
        cell.yorumText.text = yorumDizisi[indexPath.row]
        cell.postImageView.sd_setImage(with: URL(string: self.gorselDizisi[indexPath.row]))
        return cell
        }
        
        
        
        
    }
    
    
    
    

