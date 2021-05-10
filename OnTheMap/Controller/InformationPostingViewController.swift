//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by June2020 on 5/4/21.
//

import UIKit
import MapKit
import CoreLocation


class InformationPostingViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var location: UITextField!
    
    @IBOutlet weak var myLink: UITextField!
    
    
    @IBOutlet weak var myMapView: MKMapView!
    
    @IBOutlet weak var findLocationButton: UIButton!
    
    
    @IBOutlet weak var finishButton: UIButton!
    
    @IBOutlet weak var mapIcon: UIImageView!
    
    var myCLLocation: CLLocationCoordinate2D?
    
    var myAddressString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myMapView.delegate = self
        myMapView.isHidden = true
        finishButton.isHidden = true
        findLocationButton.isHidden = false
        location.isHidden = false
        myLink.isHidden = false
        mapIcon.isHidden = false
       
        
        
        
        

        // Do any additional setup after loading the view.
    }
    
// https://stackoverflow.com/questions/42279252/convert-address-to-coordinates-swift
    @IBAction func findLocationButtonTapped(_ sender: Any) {
        getCoordinate (addressString: location.text ?? "", completionHandler: handleConversion(coordinates:error:address:))
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        OTMClient.postStudentLocation(latitude: myCLLocation!.latitude, longitude: myCLLocation!.longitude, addressString: myAddressString!, mediaURL: myLink.text ?? "") { (success, error) in
            if success {
                print("Your post was completed successfully")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)            }
            } else {
                print("Sorry but your post had an error:")
                print(error)
                
            }
        }
    }
    

    // Apple documentation: https://developer.apple.com/documentation/corelocation/converting_between_coordinates_and_user-friendly_place_names
    
    func getCoordinate( addressString : String,
            completionHandler: @escaping(CLLocationCoordinate2D, NSError?, String) -> Void ) {
        let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location.coordinate, nil, addressString)
                    self.myMapView.isHidden = false
                    self.findLocationButton.isHidden = true
                    self.finishButton.isHidden = false
                    self.myLink.isHidden = true
                    self.location.isHidden = true
                    self.mapIcon.isHidden = true
                    return
                }
            } else {
                print(error)
            }
                
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?, "")
        }
    }
    
    func handleConversion(coordinates: CLLocationCoordinate2D, error: NSError?, address: String) {
        let mkAnnotation = MKPointAnnotation()
        mkAnnotation.coordinate = coordinates
        mkAnnotation.title = address
        self.myMapView.addAnnotation(mkAnnotation)
       // myMapView.setCenter(coordinates, animated: true)
        // https://stackoverflow.com/questions/41639478/mkmapview-center-and-zoom-in
       // https://developer.apple.com/documentation/mapkit/mkcoordinatespan
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        guard CLLocationCoordinate2DIsValid(coordinates) else {
            print("Your location is bad, try again.")
            return}
        // seems like a good place and time to locally store these coordinates and address for later use:
        self.myCLLocation = coordinates
        self.myAddressString = address
        myMapView.setRegion(region, animated: true)
    }
           
    func mapView(_ myMapView:MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        if let pinView = myMapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
         {
            pinView.annotation = annotation
            return pinView
        }
        else {
           var pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView.canShowCallout = true
            pinView.pinTintColor = .green
            pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            return pinView
            
        }
        
        
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)            }
    }
}
    

