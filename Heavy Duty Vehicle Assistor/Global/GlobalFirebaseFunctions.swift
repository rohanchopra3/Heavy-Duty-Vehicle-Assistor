//
//  GlobalFirebaseFunctions.swift
//  Heavy Duty vehicle Assistor
//
//  Created by Rohan Chopra on 11/03/19.
//  Copyright © 2019 Rohan Chopra. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase
import RealmSwift
import UIKit


func CreateAndUploadDriverKey() -> String {
    let ref = Database.database().reference()
    let key = ref.child(firebaseDriver).childByAutoId().key!
    ref.child(firebaseDriver).child(key).setValue(["assigned": 0])
    return key
 
}
func deleteNodeIfUserClicksBackButtonFor(Key: String){
     let ref = Database.database().reference()
     ref.child(firebaseDriver).child(Key).removeValue()
}

func UpdateRealmDBForManager(){

    let ref = Database.database().reference()
    ref.child(firebaseManager).child(getManagerEmail()).observeSingleEvent(of: .value, with: {
        (snapshot) in
        if snapshot.childrenCount > 0 {
            
            for drivers in snapshot.children.allObjects as! [DataSnapshot]{
                let value = drivers.value as! [String:Any]
    

                    print(value)
                print(drivers.key)
                UpdateRealmWith(value: value,key: drivers.key)
                
            }
            
        }
    })
}


func UpdateRealmWith(value :[String:Any] , key : String){
    
    let realm = try! Realm()
    let managerOBj = manager()
    
      if value["Name"] != nil {
    managerOBj.setValue(key, forKey: "driverkey")
    managerOBj.setValue(value["Name"]!, forKey: "drivename")
    managerOBj.setValue(value["carnumber"]!, forKey: "vehiclenumber")
        

    managerOBj.setValue(value["TollCost"]!, forKey: "TollCost")
    managerOBj.setValue(value["mobilenumber"]!, forKey: "mobilenumber")
    managerOBj.setValue(value["vehicleType"]!, forKey: "vehicleType")

    managerOBj.setValue(value["destination"]!, forKey: "destination")
    managerOBj.setValue(value["start"]!, forKey: "start")
    managerOBj.setValue(value["ontrip"], forKey: "ontripobj")

    
    try! realm.write {
        realm.add(managerOBj)
    }
    }
}

func CheckManagerNodeOnSignUP(){
    
    let ref = Database.database().reference()
    
    ref.child(firebaseManager).observeSingleEvent(of: .value, with: {
        (snapshot) in
        
        if snapshot.hasChild(getManagerEmail()){
            print("HasChild")
            UpdateRealmDBForManager()
        
        }
    })
    
}


func updateDriverDBForAssingedChildWith(value: Int){
    let ref = Database.database().reference()
    let key = keyGlob
    ref.child(firebaseDriver).child(key).child("assigned").setValue(value)
    
}
