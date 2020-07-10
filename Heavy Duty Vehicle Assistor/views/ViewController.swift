//
//  ViewController.swift
//  Heavy Duty vehicle Assistor
//
//  Created by Rohan Chopra on 10/03/19.
//  Copyright © 2019 Rohan Chopra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    
    @IBOutlet weak var Button_driver: UIButton!
    @IBOutlet weak var Button_manager: UIButton!
    @IBAction func Button_pressed(_ sender: UIButton) {
        
        if sender.titleLabel?.text! == "Manager"
        {
            self.performSegue(withIdentifier: managerSegue, sender: nil)
        }
        else{
            self.performSegue(withIdentifier: driverSegue, sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Button_driver.roundCorners()
        Button_manager.roundCorners()
    }
}

