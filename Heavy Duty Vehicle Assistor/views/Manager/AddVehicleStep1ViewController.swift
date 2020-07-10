//
//  AddVehicleStep1ViewController.swift
//  Heavy Duty Vehicle Assistor
//
//  Created by Rohan Chopra on 21/04/19.
//  Copyright © 2019 Rohan Chopra. All rights reserved.
//

import UIKit
import Firebase
var keyGlob = " "

class AddVehicleStep1ViewController: UIViewController {

    @IBOutlet weak var code: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBOutlet weak var confirm: UIButton!
    
    @IBAction func confirm(_ sender: UIButton) {
        if code.text != ""{
                checkKey()
        }

    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func checkKey(){
        let ref = Database.database().reference()
        let key = code.text
        
        self.showSpinner(onView: self.view)
        ref.child(firebaseDriver).child(key!).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if snapshot.exists(){
                let snapshotdic = snapshot.value as! [String:Any]
                self.code.resignFirstResponder()
                if snapshotdic.first?.value as! Int == 0{
                    keyGlob = key!
                    
                    self.removeSpinner()
                    self.performSegue(withIdentifier:"step2" , sender: nil)
                    
                }else{
                    let alertController = UIAlertController(title: "key Used", message: "Please enter a valid key.", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.removeSpinner()
                    self.present(alertController, animated: true, completion: nil)
                    print("error")
                }
                
            }
                
            else
            {
                let alertController = UIAlertController(title: "Wrong key", message: "Please enter a valid key.", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.removeSpinner()
                self.present(alertController, animated: true, completion: nil)
                print("error")
            }
            
        })
        
    }

}
