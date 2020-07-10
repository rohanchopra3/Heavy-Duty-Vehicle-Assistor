//
//  RealmDatabaseFunctions.swift
//  Heavy Duty vehicle Assistor
//
//  Created by Rohan Chopra on 11/03/19.
//  Copyright © 2019 Rohan Chopra. All rights reserved.
//

import Foundation
import RealmSwift

func saveDataInRealmForDriverWith(key:String){
    
    let realm = try! Realm()
    var driverObj = driver()
    driverObj.key = key
    
    try! realm.write {
        driverObj.setValue(key, forKey: "key")
        realm.add(driverObj)
    }
}

func returnKeyFromDatabse()-> String{
    var key = " "
     let realm = try! Realm()
    let driverObj = realm.objects(driver.self).first
    key = driverObj?.value(forKey: "key") as? String ?? " "
    print(key)
    return key
}

func numberOfvehicles() -> Int{
    let realm = try! Realm()
    let managerObj = realm.objects(manager.self)
    
    return managerObj.count
}

func vehicleInfo() -> Results<manager>{
    let realm = try! Realm()
    let managerObj = realm.objects(manager.self)
    
    return managerObj
}
