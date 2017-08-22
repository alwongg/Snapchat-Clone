//
//  ViewController.swift
//  Snapchat Clone
//
//  Created by Alex Wong on 8/21/17.
//  Copyright © 2017 Alex Wong. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {

    // MARK: - Properties
    
    var signUpMode = false
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - IBActions
    
    @IBAction func topPressed(_ sender: Any) {
        
        print("Top button pressed")
        
        if let email = emailTextField.text {
            if let password = passwordTextField.text {
                
                if signUpMode {
                    
                    // sign up
                    
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if let error = error {
                            
                            self.displayAlert(title: "Error", message: error.localizedDescription)
                            
                        } else {
                            
                            // add the user to firebase
                            if let user = user{
                            Database.database().reference().child("users").child(user.uid).child("email").setValue(user.email)
                            
                                
                                //everything worked!
                            
                            //print("Sign up was successful")
                            self.performSegue(withIdentifier: "moveToSnaps", sender: nil)
                            }
                        }
                    })
                    
                    
                    
                } else {
                    
                    // log in
                    
                    Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                        if let error = error {
                            
                            
                            self.displayAlert(title: "Error", message: error.localizedDescription)
                            
                        } else {
                            
                            //everything worked!
                            
                            //print("Log in was successful")
                            self.performSegue(withIdentifier: "moveToSnaps", sender: nil)
                            
                            
                        }
                    })
                    
                    
                }
                
                
                
            }
        }
        
        
        
        
    }
    
    
    @IBAction func bottomPressed(_ sender: Any) {
        
        if signUpMode {
            
            // sign up: switch to log in
            
            signUpMode = false
            
            topButton.setTitle("Log In", for: .normal)
            bottomButton.setTitle("Switch to Sign up", for: .normal)
            
            
            
            
        } else {
            signUpMode = true
            
            topButton.setTitle("Sign Up", for: .normal)
            bottomButton.setTitle("Switch to Log in", for: .normal)
           
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

extension LoginViewController: UITextFieldDelegate{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        topPressed(self)
        return true
    }
    
    
    
    
}

