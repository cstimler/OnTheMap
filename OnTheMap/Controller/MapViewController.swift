//
//  MapViewController.swift
//  OnTheMap
//
//  Created by June2020 on 5/4/21.
//

import UIKit
import MapKit
import SafariServices

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var myAnnotations: [MKPointAnnotation]?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the mapview delegate:
        mapView.delegate = self
        // load the model
        let locations = model
        // set up the annotations:
        var annotations = [MKPointAnnotation]()
        // parse the information from the model to the annotations
        for dictionary in locations {
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
        }
        // lets store annotations here:
        self.myAnnotations = annotations
        self.mapView.addAnnotations(annotations)
}


func mapView(_ mapView:MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let reuseId = "pin"
    if let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
     {
        pinView.annotation = annotation
        return pinView
    }
    else {
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView.canShowCallout = true
        // I like green
        pinView.pinTintColor = .green
        pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        return pinView
    }
    
    
}

func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    if control == view.rightCalloutAccessoryView {
        if let toOpen = view.annotation?.subtitle {
            // patch up URL if prefix is missing:
            if var toOpen = toOpen{
                if toOpen.prefix(3) == "www" {
                    toOpen = "http://" + toOpen
                }
                // check to see if URL is well formed:
                if toOpen.prefix(7) != "http://" && toOpen.prefix(8) != "https://" {
                    showMapFailure(message: "This student does not have a valid URL")
                }
                if let url = URL(string: toOpen) {
                DispatchQueue.main.async {
                    // app.show does not work well for map so I had to find another solution:
                    // https://www.hackingwithswift.com/read/32/3/how-to-use-sfsafariviewcontroller-to-browse-a-web-page
                    let config = SFSafariViewController.Configuration()
                    config.entersReaderIfAvailable = true
                    let vc = SFSafariViewController(url: url, configuration:config)
                    self.present(vc, animated: true) {
                        self.setAutoRotation(value: true)
                    }
                    }
                }
                    
}
}
}
}


    
    @IBAction func mapToInfoSegue(_ sender: Any)
        {
            performSegue(withIdentifier: "mapToInfo", sender: self)
        }
    
    // reloads the student locations and then displays these on map:
    @IBAction func reloadButtonPressed(_ sender: Any) {
        OTMClient.getStudentLocations { (success, error) in
            if success {
                DispatchQueue.main.async {
                    // it will also work if I don't remove annotations first, but the shadows will get darker!
                self.mapView.removeAnnotations(self.myAnnotations ?? [])
                self.viewDidLoad()
            }
            } else {
                self.showMapFailure(message: "There was a problem with the reload, try again.")
                print(error)
            }
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
    
    // shows alert dialog box:
    func showMapFailure(message: String) {
        DispatchQueue.main.async {
        let alertVC = UIAlertController(title: "Map Action Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertVC, animated: true, completion: nil)
    }

}
    }
    

