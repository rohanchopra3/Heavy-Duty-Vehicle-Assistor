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

let DriverDbName = "Driver"

func CreateAndUploadDriverKey() -> String {
    let ref = Database.database().reference()
    let key = ref.child(DriverDbName).childByAutoId().key!
    ref.child(DriverDbName).child(key).setValue(["assigned": 0])
    return key
 
}
func deleteNodeIfUserClicksBackButtonFor(Key: String){
     let ref = Database.database().reference()
     ref.child(DriverDbName).child(Key).removeValue()
}
