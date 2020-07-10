//
//  RealmObjects.swift
//  Heavy Duty vehicle Assistor
//
//  Created by Rohan Chopra on 11/03/19.
//  Copyright © 2019 Rohan Chopra. All rights reserved.
//

import Foundation
import RealmSwift

class driver : Object{
    @objc var key : String?

}

class manager : Object{
    @objc var ontripobj : String?
    @objc var driverkey : String?
    @objc var drivename : String?
    @objc var vehiclenumber : String?
   @objc var mobilenumber : String?
    @objc var vehicleType : String?
   @objc var TollCost : String?
    @objc var destination : String?
    @objc var start : String?
  
    func primaryKey() -> String? {
        return driverkey
    }
}
class locationObject : Object{
    @objc var driverkey : String?
    @objc var longitude : String?
    @objc var latitude : String?
}

func StoreManagerWith(email:String){
    UserDefaults.standard.set(email, forKey: "managerEmail")
}
func getManagerEmail()-> String{
    return UserDefaults.standard.value(forKey: "managerEmail") as! String
}

