//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by June2020 on 5/4/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
   
    var email: String = ""
    var password: String = ""
    
    @IBAction func pressedLogin(_ sender: Any) {
        email = emailTextField.text ?? ""
        password = passwordTextField.text ?? ""
        OTMClient.postSession(username: email, password: password) { (success, error) in
            if success {
                print("success")
                OTMClient.getPublicUserDataUdacity { (success, error) in
                    if success {
                        OTMClient.getStudentLocations {(success, error) in
                            if success {
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "loggedIn", sender: self)
                                }
                            }
                        }
                        print("success #2")
                    }
                    else {
                        print(error)
                    }
                }
            } else {
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
