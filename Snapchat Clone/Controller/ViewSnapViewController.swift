//
//  ViewSnapViewController.swift
//  Snapchat Clone
//
//  Created by Alex Wong on 8/22/17.
//  Copyright © 2017 Alex Wong. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage
import FirebaseAuth
import FirebaseStorage

class ViewSnapViewController: UIViewController {
    
    var snap: DataSnapshot?
    var imageName = ""
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let snapDictionary = snap?.value as? NSDictionary {
            if let description = snapDictionary["description"] as? String{
                if let imageURL = snapDictionary["imageURL"] as? String{
                    
                    messageLabel.text = description
                    
                    // download image from the database to set in imageview
                    // use cocoapods "pod 'SDWebImage', '~> 4.0'" to download
                    
                    if let url = URL(string: imageURL){
                        
                        imageView.sd_setImage(with: url)
                        
                    }
                    if let imageName = snapDictionary["imageName"] as? String{
                        
                        self.imageName = imageName
                        
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // called when someone hit back button and about to go to next view controller
        // delete snaps in database
        // delete images in storage
        
        if let currentUserUid = Auth.auth().currentUser?.uid{
            
            if let key = snap?.key{
                Database.database().reference().child("users").child(currentUserUid).child("snaps").child(key).removeValue()
                
                Storage.storage().reference().child("images").child(imageName).delete(completion: nil)
            }
            
        }
        
        
    }
    
}
