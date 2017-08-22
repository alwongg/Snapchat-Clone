//
//  SnapsTableViewController.swift
//  Snapchat Clone
//
//  Created by Alex Wong on 8/21/17.
//  Copyright © 2017 Alex Wong. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SnapsTableViewController: UITableViewController {
    
    var snaps: [DataSnapshot] = []
    
    
    // MARK: - Log out user
    
    
    @IBAction func logoutUser(_ sender: Any) {
        try? Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUserUid = Auth.auth().currentUser?.uid{
            Database.database().reference().child("users").child(currentUserUid).child("snaps").observe(.childAdded, with: { (snapshot) in
                self.snaps.append(snapshot)
                self.tableView.reloadData()
                
                Database.database().reference().child("users").child(currentUserUid).child("snaps").observe(.childRemoved, with: { (snapshot) in
                    
                    var index = 0
                    
                    for snap in self.snaps {
                        
                        if snapshot.key == snap.key{
                            
                            self.snaps.remove(at: index)
                            
                            
                        }
                        
                        index += 1
                    }
                    self.tableView.reloadData()
                })
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if snaps.count == 0 {
            
            
            return 1
            
        } else {
            return snaps.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = UITableViewCell()
        
        if snaps.count == 0 {
            
            cell.textLabel?.text = "You have no snaps 😪"
            
        }else {
            
            // Configure the cell...
            
            let snap = snaps[indexPath.row]
            
            if let snapDictionary = snap.value as? NSDictionary {
                if let fromEmail = snapDictionary["from"] as? String{
                    
                    cell.textLabel?.text = fromEmail
                    
                    
                }
            }
            
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if snaps.count > 0 {
        let snap = snaps[indexPath.row]
        
        performSegue(withIdentifier: "viewSnapSegue", sender: snap)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSnapSegue" {
            
            if let viewVC = segue.destination as? ViewSnapViewController{
                if let snap = sender as? DataSnapshot{
                    
                    viewVC.snap = snap
                }
                
                
            }
            
            
        }
    }
    
    
}
