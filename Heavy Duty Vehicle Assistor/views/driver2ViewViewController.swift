//
//  driver2ViewViewController.swift
//  Heavy Duty Vehicle Assistor
//
//  Created by Rohan Chopra on 22/04/19.
//  Copyright © 2019 Rohan Chopra. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import RealmSwift
class driver2ViewViewController: UIViewController , CLLocationManagerDelegate{

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var vehicleNumber: UILabel!
    @IBOutlet weak var ontrip: UIButton!
    @IBOutlet weak var tripcompleted: UIButton!
    @IBOutlet weak var mobileNumber: UILabel!
    
    @IBOutlet weak var Destination: UILabel!
    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var toll: UILabel!
    @IBOutlet weak var type: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
  
        
        getDataFromRealm()
        checkWithFirebase()
        updateData()
    }
    func getDataFromRealm(){
        let realm = try! Realm()
        
        let values = realm.objects(manager.self)
        print(values)
        if values.first != nil {
        name.text = values.first?.value(forKey: "drivename") as? String
        mobileNumber.text = values.first?.value(forKey: "mobilenumber") as? String
        vehicleNumber.text =  values.first?.value(forKey: "vehiclenumber") as? String
        source.text = values.first?.value(forKey: "start") as? String
        Destination.text = values.first?.value(forKey: "destination") as? String
        type.text = values.first?.value(forKey: "vehicleType") as? String
            
        let  tollcost = Int(String(describing: (values.first?.value(forKey: "TollCost") as! String)))
        toll.text = " ₹\(tollcost! * 2)"
        }
        
    
    }

    @IBAction func tripCompleteAction(_ sender: Any) {
        let ref = Database.database().reference()
        ref.child(firebaseManager).child(getManagerEmail()).child(returnKeyFromDatabse()).child("ontrip").setValue("1")
        
        tripcompleted.isHidden = false
        ontrip.isHidden = true
        locationManager.startUpdatingLocation()
    }
    
    
    @IBAction func onTripAction(_ sender: Any) {
        tripcompleted.isHidden = true
        ontrip.isHidden = false
               let ref = Database.database().reference()
        ref.child(firebaseManager).child(getManagerEmail()).child(returnKeyFromDatabse()).child("ontrip").setValue("0")
        
              locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
         let ref = Database.database().reference()
        ref.child("location").child(returnKeyFromDatabse()).child("latitude").setValue(locValue.latitude)
        
       ref.child("location").child(returnKeyFromDatabse()).child("longitude").setValue(locValue.longitude)
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }

    func checkWithFirebase(){
        let ref = Database.database().reference()
        ref.child(firebaseManager).child(getManagerEmail()).observe(.childRemoved, with:{
            (snapshot) in
            if snapshot.key == returnKeyFromDatabse(){
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "start")
                let realm = try! Realm()
                try! realm.write {
                    realm.deleteAll()
                }
                UpdateUserMode(mode: 0)
                
                self.present(vc, animated: true, completion: nil)
            }
        })
    }
    func updateData(){
        let realm = try! Realm()
        let ref = Database.database().reference()
        ref.child(firebaseManager).child(getManagerEmail()).observe(.childChanged, with: {(snapshot) in
            print(snapshot)
   
                let value = snapshot.value as! [String:Any]
                print(value)
              let val = realm.objects(manager.self).filter("driverkey = '\(returnKeyFromDatabse())'")
                try! realm.write {
                    val.setValue(value["destination"] , forKey: "destination")
                    val.setValue(value["start"] , forKey: "start")
                    val.setValue(value["vehicleType"] , forKey: "vehicleType")
                    val.setValue(value["TollCost"] , forKey: "TollCost")

                     self.getDataFromRealm()
                    
    
            }
        })
        
    }
}
