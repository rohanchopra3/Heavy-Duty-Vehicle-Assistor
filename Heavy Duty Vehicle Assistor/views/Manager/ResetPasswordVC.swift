//
//  ResetPasswordVC.swift
//  Heavy Duty Vehicle Assistor
//
//  Created by Rohan Chopra on 20/05/19.
//  Copyright © 2019 Rohan Chopra. All rights reserved.
//

import UIKit
import FirebaseAuth
class ResetPasswordVC: UIViewController {

    @IBOutlet weak var Email: UITextField!
    
    
}

extension ResetPasswordVC{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Email.becomeFirstResponder()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func ResetPassword(_ sender: UIButton) {
        if Email.text == ""{
            
        }
        else{
            Auth.auth().sendPasswordReset(withEmail: Email.text!, completion: {
                error in
                if let err = error{
                    print(err)
                    let alertController = UIAlertController(title: "Wrong Credentials", message: "Please enter a valid email to continue.", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }else{
                    let alertController = UIAlertController(title: "Email Sent", message: "A password reset link has been sent to your email address.", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: {
                        action in
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "manager") as! ManagerViewController
                        
                        self.present(vc, animated: true, completion: nil)
                    })
                 
                    alertController.addAction(defaultAction)
                     self.present(alertController, animated: true, completion: nil)
                    
                }
            })
        }
    }
}
