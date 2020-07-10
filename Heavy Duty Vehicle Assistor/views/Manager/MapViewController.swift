//
//  MapViewController.swift
//  Heavy Duty Vehicle Assistor
//
//  Created by Rohan Chopra on 21/04/19.
//  Copyright © 2019 Rohan Chopra. All rights reserved.
//

import UIKit
import GoogleMaps
import RealmSwift
import Firebase

class MapViewController: UIViewController  {
var markerDict: [String: GMSMarker] = [:]
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let ref = Database.database().reference()
        ref.child("location").observe(.childChanged, with: {
            (data) in
            
            let dat = data.value as! [String:Any]
         
            let realm = try! Realm()
            
            let data2 = realm.objects(manager.self)
            for object in data2{
                let key = object.value(forKey: "driverkey") as? String
                if key! == data.key {
                    
                    self.markerDict[key!]?.position = CLLocationCoordinate2D(latitude: dat["latitude"] as! CLLocationDegrees, longitude: dat["longitude"] as! CLLocationDegrees)
                }
            }
            
            
        })        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        var lat :Double?
        var lon : Double?
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            lat = (locationManager.location?.coordinate.latitude)!
             lon = (locationManager.location?.coordinate.longitude)!

        }
       
        let camera = GMSCameraPosition.camera(withLatitude: Double(lat ?? 28.704060 )  , longitude: Double(lon ?? 77.102493) , zoom: 8.0)
        
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        mapView.settings.myLocationButton = true
        let realm = try! Realm()
        
        let data = realm.objects(manager.self)
        

        for object in data{
            let key = object.value(forKey: "driverkey") as? String
             let ref = Database.database().reference()
            
            ref.child("location").child(key!).observeSingleEvent(of: .value, with:
                { (data) in
                   if let dat = data.value as? [String:Any]
                   {
                    
                    if  dat["latitude"] != nil || dat["longitude"] != nil {
                        
             
               
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: dat["latitude"] as! CLLocationDegrees, longitude: dat["longitude"] as! CLLocationDegrees)
            marker.title = object.value(forKey: "drivename") as? String
            marker.snippet = object.value(forKey: "vehiclenumber") as? String
                        marker.icon = #imageLiteral(resourceName: "imageMap")
            marker.map = mapView
                    self.markerDict[key!] = marker
                           }
                           }
            })
  
            
        }
        
        mapView.isMyLocationEnabled = true
        }
    
    
        // Creates a marker in the center of the map.

 
}
