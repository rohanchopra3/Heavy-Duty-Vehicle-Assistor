//
//  DriverViewController.swift
//  Heavy Duty vehicle Assistor
//
//  Created by Rohan Chopra on 10/03/19.
//  Copyright © 2019 Rohan Chopra. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import CoreLocation


class DriverViewController: UIViewController {
   
    @IBOutlet weak var copyBUttin: UIButton!
    
let locationManager = CLLocationManager()
    var key :String?
    @IBOutlet weak var checkButton: UIButton!
    @IBAction func Check(_ sender: UIButton) {
        
        self.showSpinner(onView: self.view)
        
        let ref = Database.database().reference()
        let key = keylabel.text
        print(key!)
        ref.child(firebaseDriver).child(key!).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if snapshot.exists(){
                let snapshotdic = snapshot.value as! [String:Any]
                print(snapshotdic)
                if snapshotdic["assigned"] as! Int == 1{
                    keyGlob = key!
                    StoreManagerWith(email: snapshotdic["manager"] as! String)
                    self.fetchDataFromFirebaseAndaddToRealm()
                    UpdateUserMode(mode: 3)
                  
                    self.removeSpinner()
                  
                }else{
                    let alertController = UIAlertController(title: "No registeration", message: "Please ask a manager to add them to your vehicle list.", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                
                    self.removeSpinner()
                    self.present(alertController, animated: true, completion: nil)
                    print("error")
                }
                
            }
          
        })
    }
    
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var keylabel: UILabel!
    @IBAction func back(_ sender: UIButton) {
      UpdateUserMode(mode: 0)
      performSegue(withIdentifier: "back", sender: nil)
        
    }
    @IBAction func copyButton(_ sender: Any) {
        UIPasteboard.general.string = keylabel.text!
    }
}



extension DriverViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.requestAlwaysAuthorization() 
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkButton.roundCorners()
        let returnedKey = returnKeyFromDatabse()
        if returnedKey == " "{
            key =  CreateAndUploadDriverKey()
            UpdateUserMode(mode: 2)
            if let Createdkey = key{
                saveDataInRealmForDriverWith(key: Createdkey)
                 keylabel.text = key
            }
            
        }
        else {
            key = returnedKey
            UpdateUserMode(mode: 2)
            keylabel.text = key
        }
    }

    func fetchDataFromFirebaseAndaddToRealm(){
        let ref = Database.database().reference()
        ref.child(firebaseManager).child(getManagerEmail()).child(keyGlob).observeSingleEvent(of: .value, with: {
            (snapshot) in
            if snapshot.childrenCount > 0 {
                
               print(snapshot.value)
                    let value = snapshot.value as! [String:Any]
                  print(value)
                    UpdateRealmWith(value: value,key: keyGlob)
                  self.performSegue(withIdentifier:"driverlog" , sender: nil)
            }
        })
    }
}
