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
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        myMapView.delegate = self
        myMapView.isHidden = true
        finishButton.isHidden = true
        findLocationButton.isHidden = false
        location.isHidden = false
        myLink.isHidden = false
       
        
        
        
        

        // Do any additional setup after loading the view.
    }
    
// https://stackoverflow.com/questions/42279252/convert-address-to-coordinates-swift
    @IBAction func findLocationButtonTapped(_ sender: Any) {
        getCoordinate (addressString: location.text ?? "", completionHandler: handleConversion(coordinates:error:address:))
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        
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
                    self.location.isHidden = true
                    self.myLink.isHidden = true
                    print(self.myLink.isHidden)
                    self.myLink.text = String(self.myLink.isHidden)
                    
                    print("Got past myLink")
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
        myMapView.setRegion(region, animated: true)
        print(self.myLink.isHidden)
    }
           
    func mapView(_ myMapView:MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        if let pinView = myMapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
         {
            print("reached annotation")
            pinView.annotation = annotation
            return pinView
        }
        else {
            print("Reached nil")
           var pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView.canShowCallout = true
            pinView.pinTintColor = .green
            pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            print(self.myLink.isHidden)
            return pinView
            
        }
        
        
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        print(self.myLink.isHidden)
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)            }
    }
}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

