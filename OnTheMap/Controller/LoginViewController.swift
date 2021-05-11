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
        OTMClient.postSession(username: email, password: password) { (success, error, message) in
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
                        self.showLoginFailure(message: "Problem with network or server.  Please ensure good internet connection and try again.")
                    }
                }
            } else {
                print(error)
                if message == "data nil" {
                    self.showLoginFailure(message: "Problem with network or server.  Please ensure adequate internet service and try again.") }
                else {
                    self.showLoginFailure(message: "Incorrect email or password.  Please try again.")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func referToUdacity(_ sender: Any) {
        let app = UIApplication.shared
        if let url = URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com"){
            app.open(url)
        } else {
            print("This person has no url")
        }
    }
    func showLoginFailure(message: String) {
        DispatchQueue.main.async {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.show(alertVC, sender: nil)
    }

}
}
