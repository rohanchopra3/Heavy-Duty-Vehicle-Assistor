//
//  VehicleVC.swift
//  Heavy Duty Vehicle Assistor
//
//  Created by Rohan Chopra on 26/05/19.
//  Copyright © 2019 Rohan Chopra. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseDatabase

class VehicleVC: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var vehicleNumber: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var source: UILabel!
    
    @IBOutlet weak var tollcost: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var tripView: UIView!
    
    var key : String?
        let references = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        CheckForOntripUpdates()
    }
    override func viewWillDisappear(_ animated: Bool) {
              references.removeAllObservers()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        ShowInfo()
    }

    func ShowInfo(){
        
        
        let realm = try! Realm()
        print(key!)
        let result = realm.objects(manager.self).filter("driverkey='\(key!)'")


        name.text = result.first?.value(forKey: "drivename") as? String
        vehicleNumber.text = result.first?.value(forKey: "vehiclenumber") as? String
        type.text = result.first?.value(forKey: "vehicleType") as? String
        source.text = result.first?.value(forKey: "start") as? String
        destination.text = result.first?.value(forKey: "destination") as? String
        number.text = result.first?.value(forKey: "mobilenumber") as? String
        
        let toll = Int(String(describing: (result.first?.value(forKey: "TollCost") as! String)))
        tollcost.text = " ₹\(toll! * 2)"
        setTrip()
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func callButton(_ sender: Any) {
        

        guard let number = URL(string: "tel://" + number.text!) else { return }
        UIApplication.shared.open(number)
    }
    
    @IBAction func DeleteDriver(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Delete Driver", message: "Warning! This will delete all information of this driver.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .destructive, handler: {
            action in
            let ref = Database.database().reference()
            ref.child(firebaseManager).child(getManagerEmail()).child(self.key!).removeValue()
            let realm = try! Realm()
            let result = realm.objects(manager.self).filter("driverkey='\(self.key!)'")
            try! realm.write {
                realm.delete(result)
            }
            
            self.dismiss(animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            
        })
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func tripCompleted(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Completed") as! CompletedVC
        vc.key = key!
        self.present(vc, animated: true, completion: nil)

    }
    
    
    func setTrip(){
        let realm = try! Realm()
        print(key!)
        let result = realm.objects(manager.self).filter("driverkey='\(key!)'")
        if  result.first?.value(forKey: "ontripobj") as? String == "0"{
            tripView.backgroundColor = #colorLiteral(red: 0.8271653177, green: 0.09893415018, blue: 0.07533499948, alpha: 1)
        }
        else{
            tripView.backgroundColor = #colorLiteral(red: 0.2121329308, green: 0.712343812, blue: 0.1998942196, alpha: 1)
        }
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
               self.setTrip()
                
            }
        })
        
    }
}
