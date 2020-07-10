//
//  AddVehicleStep2ViewController.swift
//  Heavy Duty Vehicle Assistor
//
//  Created by Rohan Chopra on 21/04/19.
//  Copyright © 2019 Rohan Chopra. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
import DropDown

class AddVehicleStep2ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var vehicleNumber: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var type: UITextField!
    @IBOutlet weak var source: UITextField!
    @IBOutlet weak var destination: UITextField!
   
    let dropDown = DropDown()
    let dropdown2 = DropDown()
    let dropdown3 = DropDown()
    
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
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField  == self.type {
            mobileNumber.resignFirstResponder()
            textField.resignFirstResponder()
            dropDown.show()
        }
        else if textField == self.source{
            mobileNumber.resignFirstResponder()
             textField.resignFirstResponder()
            dropdown2.show()
        }else if textField == self.destination{
            mobileNumber.resignFirstResponder()
             textField.resignFirstResponder()
            dropdown3.show()
        }
    }
 
    
    @IBAction func confirm(_ sender: Any) {
        
        self.showSpinner(onView: self.view)
        if name.text != "" && mobileNumber.text != "" && vehicleNumber.text != "" && type.text != "" && destination.text != "" && source.text != "" && source.text != destination.text  {
            updateDriverDBForAssingedChildWith(value:1)
            UpdateAndAddtoRealm()
            calcToll(source: source.text!, destination: destination.text!, type: type.text!, key: keyGlob)
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
    
    func UpdateAndAddtoRealm(){
        
        let ref = Database.database().reference()
        let valueDriver: [String:Any] = ["assigned" : 1 , "manager": getManagerEmail()]
        ref.child(firebaseDriver).child(keyGlob).setValue(valueDriver)
        let values : [String :Any] = ["Name" : name.text! , "TollCost" : "1000" ,"carnumber": vehicleNumber.text! , "destination" : destination.text! , "mobilenumber": mobileNumber.text! ,"ontrip": "0","start": source.text!,"vehicleType" : type.text! ]
        ref.child(firebaseManager).child(getManagerEmail()).child(keyGlob).setValue(values)
        
        UpdateRealmWith(value: values, key: keyGlob)

    }
    
    @IBAction func Cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)

    }
    
}

func calcToll(source: String, destination :String , type : String ,key : String){
    var cost = "0"
    let fir = Database.database().reference()
    let no1 = "\(source) - \(destination)"
    let no2 = "\(destination) - \(source)"
    var na = "single trip"
    if type == "6 wheeler"{
        na = "single trip "
    }
    let realm = try! Realm()
    let result = realm.objects(manager.self).filter("driverkey='\(key)'")
    
    fir.child("TollInfor").child(no1).child(type).observeSingleEvent(of: .value, with: {
        (snapshot) in
        
        if snapshot.exists() {
            let value = snapshot.value as! [String: Any]
            cost = "\(String(describing: value[na]!))"
            try! realm.write {
                result.setValue(cost, forKey: "TollCost")
            }
                   fir.child(firebaseManager).child(getManagerEmail()).child(key).child("TollCost").setValue(cost)
            print(cost)
        }else{
            fir.child("TollInfor").child(no2).child(type).observeSingleEvent(of: .value, with: {
                (snapshot2) in
                if snapshot2.exists() {
                    let value2 = snapshot2.value as! [String: Any]
                    cost = "\(String(describing: value2[na]!))"
                    print(cost)
                    try! realm.write {
                        result.setValue(cost, forKey: "TollCost")
                    }
                    fir.child(firebaseManager).child(getManagerEmail()).child(key).child("TollCost").setValue(cost)
                }
            })
        }
    })
    
    
    
  
  
}
