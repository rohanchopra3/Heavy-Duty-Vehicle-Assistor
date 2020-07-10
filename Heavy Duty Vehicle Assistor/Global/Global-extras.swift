//
//  File.swift
//  Heavy Duty vehicle Assistor
//
//  Created by Rohan Chopra on 10/03/19.
//  Copyright © 2019 Rohan Chopra. All rights reserved.
//

import Foundation
import UIKit

var managerSegue = "managerbuttonpressed"
var driverSegue = "driverbuttonpressed"
var userMode = "userMode"
var driverStoryBoardId = "driver"
var driverHomeStoryBoardId = "driverHome"
var ManagerStoryBoardId = "HomepageManager"
var startPageStoryBoardID = "start"
var addvehicleID = "addvehicle"


//FIREBASE CHILD NAMES

var firebaseManager = "Manager"
var firebaseDriver = "Driver"
var firebaseToll = "TollInfor"
var firebaseLocation = "location"

func UpdateUserMode(mode:Int){
    //0 for none , 1 for manager , 2 for driver
    UserDefaults.standard.setValue(mode, forKey: userMode)
}

func checkUserMode(window: UIWindow?){
    
    if let mode = UserDefaults.standard.value(forKey: userMode) as? Int{
        if mode == 1{
            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier:ManagerStoryBoardId) as UIViewController
         
            window?.rootViewController = initialViewControlleripad
            window?.makeKeyAndVisible()

        }
        else if mode == 2
        {
            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: driverStoryBoardId) as UIViewController
            
            window?.rootViewController = initialViewControlleripad
            window?.makeKeyAndVisible()
        }
        else if mode == 3
        {
            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: driverHomeStoryBoardId) as UIViewController
            
            window?.rootViewController = initialViewControlleripad
            window?.makeKeyAndVisible()
        }
        else{
            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: startPageStoryBoardID) as UIViewController
            
            window?.rootViewController = initialViewControlleripad
            window?.makeKeyAndVisible()
        }
    }
    else{
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: startPageStoryBoardID) as UIViewController
        
        window?.rootViewController = initialViewControlleripad
        window?.makeKeyAndVisible()
        
    }
}

extension UIButton {
    func roundCorners() {
            self.clipsToBounds = false
            self.layer.cornerRadius = 0.5 * self.frame.height
    }
}

extension UIView{
    func roundCorner() {
        self.clipsToBounds = false
        self.layer.cornerRadius = 0.5 * self.frame.height
    }
}


var vSpinner : UIView?

extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
