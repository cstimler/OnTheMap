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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let locations = model
        var annotations = [MKPointAnnotation]()
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
        pinView.pinTintColor = .green
        pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        return pinView
    }
    
    
}

func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    if control == view.rightCalloutAccessoryView {
       // let app = UIApplication.shared
        if var toOpen = view.annotation?.subtitle {
            if var toOpen = toOpen{
                if toOpen.prefix(3) == "www" {
                    toOpen = "http://" + toOpen
                }
                if toOpen.prefix(7) != "http://" && toOpen.prefix(8) != "https://" {
                    print("Your URL is incorrectly formatted")
                    showMapFailure(message: "This student does not have a valid URL")
                }
                if let url = URL(string: toOpen) {
                DispatchQueue.main.async {
                    // https://www.hackingwithswift.com/read/32/3/how-to-use-sfsafariviewcontroller-to-browse-a-web-page
                    let config = SFSafariViewController.Configuration()
                    config.entersReaderIfAvailable = true
                    let vc = SFSafariViewController(url: url, configuration:config)
                    self.present(vc, animated: true)
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
                print("There was an error with the reload")
                print(error)
            }
        }
    }
    
    
    @IBAction func dismissAndLogout(_ sender: Any) {
        OTMClient.logout {
            print("Logged out.")
        }
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)            }
    }
    
    func showMapFailure(message: String) {
        DispatchQueue.main.async {
        let alertVC = UIAlertController(title: "Map Action Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertVC, animated: true, completion: nil)
    }

}
    }
    

