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
    
    //  I used code from the following website to keep this view controller in portrait orientation: https://stackoverflow.com/questions/36358032/override-app-orientation-setting/48120684#48120684
    
    func setAutoRotation(value: Bool) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
       appDelegate.autoRotation = value
    }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAutoRotation(value: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setAutoRotation(value: true)
    }
    
    @IBAction func pressedLogin(_ sender: Any) {
        email = emailTextField.text ?? ""
        password = passwordTextField.text ?? ""
        // first post session
        OTMClient.postSession(username: email, password: password) { (success, error, message) in
            if success {
                // next get
                OTMClient.getPublicUserDataUdacity { (success, error) in
                    if success {
                        OTMClient.getStudentLocations {(success, error) in
                            if success {
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "loggedIn", sender: self)
                                }
                            } else {
                                self.showLoginFailure(message: "Unable to download student locations")
                            }
                        }
                    }
                    else {
                        // if unable to get public user data:
                        self.showLoginFailure(message: "Problem with network or server.  Please ensure good internet connection and try again.")
                    }
                }
            } else {
                // if unable to post session might be due to either network problem or incorrect user credentials
                if message == "data nil" {
                    self.showLoginFailure(message: "Problem with network or server.  Please ensure adequate internet service and try again.") }
                else {
                    self.showLoginFailure(message: "Incorrect email or password.  Please try again.")
                }
            }
        }
    }
    
    // if user wants to register with Udacity:
    @IBAction func referToUdacity(_ sender: Any) {
        let app = UIApplication.shared
        if let url = URL(string: "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com"){
            app.open(url)
        } else {
            showLoginFailure(message: "Referral Failed: Try connecting to Udacity again later.")
        }
    }
    
    // displays alert dialog:
    func showLoginFailure(message: String) {
        DispatchQueue.main.async {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.show(alertVC, sender: nil)
    }
}
}
