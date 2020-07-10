//
//  ManagerViewController.swift
//  Heavy Duty vehicle Assistor
//
//  Created by Rohan Chopra on 11/03/19.
//  Copyright © 2019 Rohan Chopra. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ManagerViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
   
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self

    }
    
    @IBAction func signUp(_ sender: UIButton) {
        self.performSegue(withIdentifier: "signup", sender: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func login(_ sender: UIButton) {
        self.showSpinner(onView: self.view)
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            passwordTextField.resignFirstResponder()
            
            let alertController = UIAlertController(title: "Wrong Credentials", message: "Please enter a valid email and password to continue.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.removeSpinner()
            self.present(alertController, animated: true, completion: nil)
            
        } else {
                 passwordTextField.resignFirstResponder()
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil {
               
                    StoreManagerWith(email: self.passwordTextField.text!)
                    
                    
                    CheckManagerNodeOnSignUP()
                    let timer2 = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomepageManager")
                             UpdateUserMode(mode: 1)
                        self.removeSpinner()
                        self.present(vc!, animated: true, completion: nil)
                    }
                   
                    
                } else {
                    self.passwordTextField.resignFirstResponder()
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Wrong Credentials", message: "Please enter a valid email and password to continue.", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.removeSpinner()
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
}
