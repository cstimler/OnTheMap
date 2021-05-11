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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var myCLLocation: CLLocationCoordinate2D?
    
    var myAddressString: String?
    
    var myGeocoder: CLGeocoder?
    
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
        if location.text == "" {
            self.showInformationFailure(message: "Please enter a location!")
        } else if self.myLink.text == "" {
                self.showInformationFailure(message: "Please enter a link!")
            } else {
                setGeocodingIn(true)
        getCoordinate (addressString: location.text!, completionHandler: handleConversion(coordinates:error:address:))
    }
    }
    
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        var totalMessage: String=""
        OTMClient.postStudentLocation(latitude: myCLLocation!.latitude, longitude: myCLLocation!.longitude, addressString: myAddressString!, mediaURL: myLink.text) { (success, error, message) in
            if success {
                print("Your post was completed successfully")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)            }
            } else {
                print("Got to message handler!!!!")
                if let message = message {
                    totalMessage = "Sorry, but your post failed" + message
                } else {
                totalMessage = "Sorry, but your post failed."
                }
                self.showInformationFailure(message: totalMessage)
                print("Sorry but your post had an error:")
                print(error)
                
            }
        }
    }
    
    

    // Apple documentation: https://developer.apple.com/documentation/corelocation/converting_between_coordinates_and_user-friendly_place_names
    
    func getCoordinate( addressString : String,
            completionHandler: @escaping(CLLocationCoordinate2D, NSError?, String) -> Void ) {
        if addressString == "" {
            showInformationFailure(message: "Please enter an address!")
            return
        }
        let geocoder = CLGeocoder()
        self.myGeocoder = geocoder
        // https://stackoverflow.com/questions/19443635/clgeocoder-how-to-set-timeout/44266971 and:
        // https://www.hackingwithswift.com/articles/117/the-ultimate-guide-to-timer
        let timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.timeout), userInfo: nil, repeats: false)
        RunLoop.current.add(timer, forMode: .common)
            geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location.coordinate, nil, addressString)
                    self.setGeocodingIn(false)
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
                self.setGeocodingIn(false)
                self.showInformationFailure(message: "Your geocode failed: The server might be down or the address might be bad.  Clarify the address and try again later.")
            }
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?, "")
        }
    }
    
    @objc func timeout()
    {
        if let myGeocoder = self.myGeocoder {
        if (myGeocoder.isGeocoding){
            myGeocoder.cancelGeocode()
            self.showInformationFailure(message: "Network error, cannot geocode!  Try again when internet is working.")
        }
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
            self.showInformationFailure(message: "Your geocode failed: Your entered location has an error. Try clarifying the address and try again.")
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
    
    func showInformationFailure(message: String) {
        DispatchQueue.main.async {
        let alertVC = UIAlertController(title: "Information Action Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.show(alertVC, sender: nil)
    }

}
    
    func setGeocodingIn(_ geocodingIn: Bool) {
        if geocodingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func dismissView(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)            }
    }

    

}
