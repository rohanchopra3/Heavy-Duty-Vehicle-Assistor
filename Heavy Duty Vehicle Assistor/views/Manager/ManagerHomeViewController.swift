//
//  ManagerHomeViewController.swift
//  Heavy Duty Vehicle Assistor
//
//  Created by Rohan Chopra on 21/04/19.
//  Copyright © 2019 Rohan Chopra. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
import CoreLocation

class ManagerHomeViewController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate{
    let locationManager = CLLocationManager()
    @IBAction func logOut(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Log Out", message: "Warning! This will log you out and you wil be returned to home page.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .destructive, handler: {
            action in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "start")
            let realm = try! Realm()
            try! realm.write {
                realm.deleteAll()
            }
            UpdateUserMode(mode: 0)
            
            self.present(vc, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            
        })
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
    
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
 
    var stat = 0

}
        let references = Database.database().reference()
extension ManagerHomeViewController {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfvehicles()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ManagerViewCell
        
        let info = vehicleInfo()[indexPath.row]
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        cell.contentView.backgroundColor = UIColor.white
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        cell.Name.text = info.value(forKey: "drivename") as? String
        cell.number.text = info.value(forKey: "vehiclenumber") as? String
        cell.tripView.roundCorner()
        cell.type.text = info.value(forKey: "vehicleType") as? String
        if info.value(forKey: "ontripobj") as! String == "1"{
            cell.tripView.backgroundColor = #colorLiteral(red: 0.0800480837, green: 0.8271653177, blue: 0.2891192852, alpha: 1)
            
            print("trip")
        }else{
            print("notrip")
            cell.tripView.backgroundColor = #colorLiteral(red: 0.8722318411, green: 0.2078492641, blue: 0.166634202, alpha: 1)
            
        }
       
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
         let info = vehicleInfo()[indexPath.row]

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "vehicle") as! VehicleVC
        vc.key = info.value(forKey: "driverkey") as? String
  
        self.present(vc, animated: true, completion: nil)

        
    }
    
    @IBAction func addvehicle(_ sender: Any) {
        self.performSegue(withIdentifier: addvehicleID, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CheckForOntripUpdates()
            locationManager.requestAlwaysAuthorization()
      
      
    }
   
    override func viewWillAppear(_ animated: Bool) {
       self.collectionView.reloadData()
    }
    override func viewDidDisappear(_ animated: Bool) {
        references.removeAllObservers()
    }
    
    func CheckForOntripUpdates(){

        references.child(firebaseManager).child(getManagerEmail()).observe(.childChanged, with: {
            (snapshot) in
            
            let value = snapshot.value as! [String:Any]

            print(snapshot.key)
            
            let realm = try! Realm()
            let val = realm.objects(manager.self).filter("driverkey = '\(snapshot.key)'")
            
           try! realm.write {
                val.setValue(value["ontrip"], forKey: "ontripobj")
                self.collectionView.reloadData()
    
            }
        })
    
    }
    
    
    
}
