//
//  SelectPictureViewController.swift
//  Snapchat Clone
//
//  Created by Alex Wong on 8/21/17.
//  Copyright © 2017 Alex Wong. All rights reserved.
//

import UIKit
import FirebaseStorage

class SelectPictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    var imagePicker: UIImagePickerController?
    var imageAdded = false
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageTextField: UITextField!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        
        
    }
    
    // MARK: - IBActions
    
    // MARK: - Select Photo From Album
    
    @IBAction func selectPhotoFromAlbum(_ sender: Any) {
        
        if imagePicker != nil{
            imagePicker?.sourceType = .photoLibrary
            
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    // MARK: - Select Photo From Camera
    
    @IBAction func selectFromCamera(_ sender: Any) {
        
        if imagePicker != nil {
            imagePicker?.sourceType = .camera
            
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    // MARK: - Proceed To Send Snaps
    
    @IBAction func nextTapped(_ sender: Any) {
        
        if let message = messageTextField.text {
            if imageAdded && message != ""{
                
                // upload the image
                // create images folder in firebase storage
                let imagesFolder = Storage.storage().reference().child("images")
                
                // turn image into some data that we can work with
                // check if an image is present
                if let image = imageView.image {
                    
                    // now convert the image to jpeg data
                    if let imageData = UIImageJPEGRepresentation(image, 0.1){
                        
                        // we have the image data, store it in the image folder in firebase
                        imagesFolder.child("\(NSUUID().uuidString).jpg").putData(imageData, metadata: nil, completion: { (metadata, error) in
                            
                            // check if there's an error, display message if error != nil
                            if let error = error{
                                
                                self.displayAlert(title: "Error", message: error.localizedDescription)
                                
                                
                            } else {
                                
                            // ready - no errors
                            // segue to next view controller
                            // download the image from firebase and store in a variable to send data to next view controller
                                if let downloadURL = metadata?.downloadURL()?.absoluteString as? String{
                                    
                                    self.performSegue(withIdentifier: "selectReceiverSegue", sender: downloadURL)
                                    
                                }
                               
                            }
                        })
                    }
                    
                }
             
            } else {
                
                // if there's no image or message text field is empty
                displayAlert(title: "Error", message: "You must provide an image and a message for your snap")
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let downloadURL = sender as? String {
            
            if let selectVC = segue.destination as? SelectRecipientTableViewController {
                
                selectVC.downloadURL = downloadURL
                selectVC.snapDescription = messageTextField.text!
                
            }
            
            
        }
    }
    
    // MARK: - UIImagePickerController
    
    // MARK: - DidFinishPickingMedia
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            imageView.image = image
            imageAdded = true
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - DidCancelPickerController
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Display Alert
    
    func displayAlert(title: String, message: String) {
        
        // create the alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // create the actions when display is shown
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        // add OK action
        alertController.addAction(okAction)
        
        // present alert view controller
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension SelectPictureViewController: UITextFieldDelegate{

    // MARK: - Dismiss keyboard when tapped outside
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Dismiss keyboard when return key is pressed
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
