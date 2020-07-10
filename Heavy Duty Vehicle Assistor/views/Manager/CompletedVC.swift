//
//  CompletedVC.swift
//  Heavy Duty Vehicle Assistor
//
//  Created by Rohan Chopra on 27/05/19.
//  Copyright © 2019 Rohan Chopra. All rights reserved.
//

import UIKit
import DropDown
import RealmSwift
import FirebaseDatabase

class CompletedVC: UIViewController, UITextFieldDelegate {
    
    var key : String?
    let dropDown = DropDown()
    let dropdown2 = DropDown()
    let dropdown3 = DropDown()
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var destination: UITextField!
    
    @IBOutlet weak var source: UITextField!
    @IBOutlet weak var type: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        dropDown.anchorView = type
        dropDown.dataSource = ["Light vehicle","6 wheeler"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.type.text = item
            self.dropDown.hide()
            
        }
        dropDown.width = 200
        
        dropdown2.anchorView = source
        dropdown2.dataSource = ["Delhi","Chandigarh","Bangaluru", "Jaipur","Agartala","Aizawl","Bhopal","Bhubaneswar" ,"Chennai","Dehradun","Dispur","Gandhinagar","Gangtok" ,"Hyderabad","Imphal","Itanagar","Kohima","Kolkata","Lucknow","Mumbai"," Panaji","Patna","Raipur","Ranchi","Shillong","Shimla","Srinagar","Thiruvananthpuram"]
        dropdown2.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.source.text = item
            self.dropdown2.hide()
            
        }
        dropdown2.width = 200
        
        dropdown3.anchorView = destination
        dropdown3.dataSource = ["Delhi","Chandigarh","Bangaluru", "Jaipur","Agartala","Aizawl","Bhopal","Bhubaneswar" ,"Chennai","Dehradun","Dispur","Gandhinagar","Gangtok" ,"Hyderabad","Imphal","Itanagar","Kohima","Kolkata","Lucknow","Mumbai"," Panaji","Patna","Raipur","Ranchi","Shillong","Shimla","Srinagar","Thiruvananthpuram"]
        dropdown3.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.destination.text = item
            self.dropdown3.hide()
            
        }
        dropdown3.width = 200
        // Do any additional setup after loading the view.
    }
    
    @IBAction func updateInfo(_ sender: Any) {
        self.showSpinner(onView: self.view)
     
        if type.text != "" && destination.text != "" && source.text != "" && source.text != destination.text  {
            let realm = try! Realm()
            let result = realm.objects(manager.self).filter("driverkey='\(key!)'")
            try! realm.write {
                result.setValue(destination.text!, forKey: "destination")
                result.setValue(source.text!, forKey: "start")
                result.setValue(type.text!, forKey: "vehicleType")
            }
            
            let ref = Database.database().reference().child(firebaseManager).child(getManagerEmail())
            
            ref.child(key!).child("destination").setValue(destination.text!)
            ref.child(key!).child("start").setValue(source.text!)
            ref.child(key!).child("vehicleType").setValue(type.text!)

            calcToll(source: source.text!, destination: destination.text!, type: type.text!, key: key!)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomepageManager")
            
            self.removeSpinner()
            self.present(vc, animated: true, completion: nil)
            
        }
        else if source.text == destination.text {
            let alertController = UIAlertController(title: "Wrong Credentials", message: "Source and destination cannot be same.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.removeSpinner()
            self.present(alertController, animated: true, completion: nil)
            
        }
        else {
            let alertController = UIAlertController(title: "Wrong Credentials", message: "Please enter a valid values to continue.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.removeSpinner()
            self.present(alertController, animated: true, completion: nil)
            
        }
    
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField  == self.type {
            textField.resignFirstResponder()
            dropDown.show()
        }
        else if textField == self.source{
            textField.resignFirstResponder()
            dropdown2.show()
        }else if textField == self.destination{
            textField.resignFirstResponder()
            dropdown3.show()
        }
    }

}
