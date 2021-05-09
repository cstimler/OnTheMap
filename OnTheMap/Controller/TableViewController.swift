//
//  TableViewController.swift
//  OnTheMap
//
//  Created by June2020 on 5/4/21.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell")!
        let user = model[(indexPath as NSIndexPath).row]
        cell.imageView?.image = UIImage(named: "icon_pin" )
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
        cell.detailTextLabel?.text = user.createdAt
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        var toOpen = model[(indexPath as NSIndexPath).row].mediaURL
            if toOpen.prefix(3) == "www" {
                toOpen = "http://" + toOpen
            }
        if let url = URL(string: toOpen){
            app.open(url)
        } else {
            print("This person has no url")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func dismissAndLogout(_ sender: Any) {
        OTMClient.logout {
            print("Logged out.")
        }
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)            }
    }
    }

