//
//  TableViewController.swift
//  OnTheMap
//
//  Created by June2020 on 5/4/21.
//

import UIKit

class TableViewController: UITableViewController  {
    
    //  I used code from the following website to allow this view controller rotations: https://stackoverflow.com/questions/36358032/override-app-orientation-setting/48120684#48120684
    
    func setAutoRotation(value: Bool) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
       appDelegate.autoRotation = value
    }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAutoRotation(value: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setAutoRotation(value: false)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell")!
        let user = model[(indexPath as NSIndexPath).row]
        cell.imageView?.image = UIImage(named: "icon_pin" )
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
        cell.detailTextLabel?.text = user.createdAt
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        var toOpen = model[(indexPath as NSIndexPath).row].mediaURL
        // patch up incomplete URL:
            if toOpen.prefix(3) == "www" {
                toOpen = "http://" + toOpen
            }
        // check to see if URL is well formed:
        if toOpen.prefix(7) != "http://" && toOpen.prefix(8) != "https://" {
            // show alert if user tries to access poorly formed URL from tableview:
            self.showTableFailure(message: "This student does not have a valid URL.  Try a different student")
        } else {
        if let url = URL(string: toOpen){
            setAutoRotation(value: true)
            app.open(url)
        } else {
            // just in case a poorly formed URL somehow made it through:
            self.showTableFailure(message: "This student does not have a valid URL.  Try a different student")
        }
    }
    }
    // reload button gets updated student locations and then reloads the table view:
    @IBAction func reloadButtonPressed(_ sender: Any) {
        OTMClient.getStudentLocations { (success, error) in
            if success {
                DispatchQueue.main.async {
                    // it will also work if I don't remove annotations first, but the shadows will get darker!
                        self.tableView.reloadData()
            }
            } else {
                self.showTableFailure(message: "There was an error with the reload, try again.")
                print(error)
            }
        }
    }
    
    
    @IBAction func tableToInfoSegue(_ sender: Any) {
        performSegue(withIdentifier: "tableToInfo", sender: self)
    }
    
    // function that calls the alert controller:
    func showTableFailure(message: String) {
        DispatchQueue.main.async {
        let alertVC = UIAlertController(title: "Table Action Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertVC, animated: true, completion: nil)
    }

}
    // logout:
    @IBAction func dismissAndLogout(_ sender: Any) {
        OTMClient.logout {
            print("Logged out.")
        }
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)            }
    }
    }

