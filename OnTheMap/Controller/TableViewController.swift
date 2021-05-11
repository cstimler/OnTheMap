//
//  TableViewController.swift
//  OnTheMap
//
//  Created by June2020 on 5/4/21.
//

import UIKit

class TableViewController: UITableViewController  {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
            if toOpen.prefix(3) == "www" {
                toOpen = "http://" + toOpen
            }
        if toOpen.prefix(7) != "http://" && toOpen.prefix(8) != "https://" {
            print("Your URL is incorrectly formatted")
            self.showTableFailure(message: "This student does not have a valid URL.  Try a different student")
        } else {
        if let url = URL(string: toOpen){
            app.open(url)
        } else {
            print("This person has no url")
            self.showTableFailure(message: "This student does not have a valid URL.  Try a different student")
        }
    }
    }
    
    @IBAction func reloadButtonPressed(_ sender: Any) {
        OTMClient.getStudentLocations { (success, error) in
            if success {
                DispatchQueue.main.async {
                    // it will also work if I don't remove annotations first, but the shadows will get darker!
                        self.tableView.reloadData()
            }
            } else {
                print("There was an error with the reload")
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func tableToInfoSegue(_ sender: Any) {
        print("about to segue")
        performSegue(withIdentifier: "tableToInfo", sender: self)
    }
    

    func showTableFailure(message: String) {
        DispatchQueue.main.async {
        let alertVC = UIAlertController(title: "Table Action Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertVC, animated: true, completion: nil)
    }

}

    @IBAction func dismissAndLogout(_ sender: Any) {
        OTMClient.logout {
            print("Logged out.")
        }
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)            }
    }
    }

