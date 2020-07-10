//
//  SignUpViewController.swift
//  Heavy Duty vehicle Assistor
//
//  Created by Rohan Chopra on 13/03/19.
//  Copyright © 2019 Rohan Chopra. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController ,UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var retypePassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
  textField.resignFirstResponder()
    }
    @IBAction func CreateAccount(_ sender: UIButton) {
        
        self.showSpinner(onView: self.view)
        if emailTextField.text == "" && passwordTextField.text == ""{
            self.removeSpinner()
            let alertController = UIAlertController(title: "Wrong Credentials", message: "Please enter a valid email and password to continue.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else if passwordTextField.text != retypePassword.text {
            self.removeSpinner()
            
            let alertController = UIAlertController(title: "Wrong Credentials", message: "Both ", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
        }else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    
                    self.retypePassword.resignFirstResponder()
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "manager")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
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


