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
    
    //  I used code from the following website to allow/disallow this view controller rotations: https://stackoverflow.com/questions/36358032/override-app-orientation-setting/48120684#48120684
    
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
    
    // when loading the page there is a hidden view consisting of the map and the
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myMapView.delegate = self
        manageHiddenViews(false)
    }
    
// https://stackoverflow.com/questions/42279252/convert-address-to-coordinates-swift
    @IBAction func findLocationButtonTapped(_ sender: Any) {
        // notify user if they have left out the location or link information:
        if location.text == "" {
            self.showInformationFailure(message: "Please enter a location!")
        } else if self.myLink.text == "" {
                self.showInformationFailure(message: "Please enter a link!")
            } else {
                // start the activity indicator:
                setGeocodingIn(true)
        getCoordinate (addressString: location.text!, completionHandler: handleConversion(coordinates:error:address:))
    }
    }
    
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        var totalMessage: String=""
        OTMClient.postStudentLocation(latitude: myCLLocation!.latitude, longitude: myCLLocation!.longitude, addressString: myAddressString!, mediaURL: myLink.text) { (success, error, message) in
            if success {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)            }
            } else {
                if let message = message {
                    totalMessage = "Sorry, but your post failed" + message
                } else {
                totalMessage = "Sorry, but your post failed."
                }
                self.showInformationFailure(message: totalMessage)
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
        // save the current instance of geocoder for use with the timer
        self.myGeocoder = geocoder
        // https://stackoverflow.com/questions/19443635/clgeocoder-how-to-set-timeout/44266971 and:
        // https://www.hackingwithswift.com/articles/117/the-ultimate-guide-to-timer
        // time will trigger an error if no response 5 seconds after pressing find location button:
        let timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.timeout), userInfo: nil, repeats: false)
        RunLoop.current.add(timer, forMode: .common)
            geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location.coordinate, nil, addressString)
                    // turn off the activity indicator
                    self.setGeocodingIn(false)
                    self.manageHiddenViews(true)
                }
            } else {
                print(error)
                // turn off the activity indicator
                self.setGeocodingIn(false)
                // geocode has returned with an error = either due to bad server OR bad address, can't be sure:
                self.showInformationFailure(message: "Your geocode failed: The server might be down or the address might be bad.  Clarify the address and try again later.")
            }
        }
    }
    
    // timeout function cancels geocoder if it is still running 5 seconds after it was triggered:
    @objc func timeout()
    {
        if let myGeocoder = self.myGeocoder {
        if (myGeocoder.isGeocoding){
            myGeocoder.cancelGeocode()
            // message indicates internet connection is down:
            self.showInformationFailure(message: "Network error, cannot geocode!  Try again when internet is working.")
        }
    }
    }
    
    func handleConversion(coordinates: CLLocationCoordinate2D, error: NSError?, address: String) {
        let mkAnnotation = MKPointAnnotation()
        mkAnnotation.coordinate = coordinates
        mkAnnotation.title = address
        self.myMapView.addAnnotation(mkAnnotation)
        // https://stackoverflow.com/questions/41639478/mkmapview-center-and-zoom-in
       // https://developer.apple.com/documentation/mapkit/mkcoordinatespan
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        // print(coordinates) - good point to debug if problems!
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
    // This function displays the alert box in case of errors:
    func showInformationFailure(message: String) {
        DispatchQueue.main.async {
        let alertVC = UIAlertController(title: "Information Action Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.show(alertVC, sender: nil)
    }

}
    // manages activity indicator:
    func setGeocodingIn(_ geocodingIn: Bool) {
        if geocodingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    // coordinates the subviews:
   func manageHiddenViews(_ hiddenView: Bool) {
    myMapView.isHidden = !hiddenView
    finishButton.isHidden = !hiddenView
    findLocationButton.isHidden = hiddenView
    location.isHidden = hiddenView
    myLink.isHidden = hiddenView
    mapIcon.isHidden = hiddenView
    setAutoRotation(value: hiddenView)
    }
    
    @IBAction func dismissView(_ sender: Any) {
        setAutoRotation(value: true)
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)            }
    }

    

}
