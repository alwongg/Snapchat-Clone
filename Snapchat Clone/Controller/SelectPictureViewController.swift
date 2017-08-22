//
//  SelectPictureViewController.swift
//  Snapchat Clone
//
//  Created by Alex Wong on 8/21/17.
//  Copyright © 2017 Alex Wong. All rights reserved.
//

import UIKit

class SelectPictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var imagePicker: UIImagePickerController?
    var imageAdded = false
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageTextField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        
        
    }
    
    @IBAction func selectPhotoFromAlbum(_ sender: Any) {
        
        if imagePicker != nil{
            imagePicker?.sourceType = .photoLibrary
            
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    @IBAction func selectFromCamera(_ sender: Any) {
        
        if imagePicker != nil {
            imagePicker?.sourceType = .camera
            
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            imageView.image = image
            imageAdded = true
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func nextTapped(_ sender: Any) {
        
        if let message = messageTextField.text {
            if imageAdded && message != ""{
                
                // segue to next view controller
                
                
                
                
            } else {
                
                
                displayAlert(title: "Error", message: "You must provide an image and a message for your snap")
                
                
            }
            
            
            
            
        }
        
        
        
        
        
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension SelectPictureViewController: UITextFieldDelegate{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
