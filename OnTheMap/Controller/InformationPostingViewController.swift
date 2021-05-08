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
    
    @IBOutlet weak var link: UITextField!
    
    
    @IBOutlet weak var myMapView: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myMapView.delegate = self
        
        
        

        // Do any additional setup after loading the view.
    }
    
// https://stackoverflow.com/questions/42279252/convert-address-to-coordinates-swift
    @IBAction func buttonTapped(_ sender: UIButton) {getCoordinate (addressString: location.text ?? "", completionHandler: handleConversion(coordinates:error:address:))
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
                    return
                }
            }
                
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?, "")
        }
    }
    
    func handleConversion(coordinates: CLLocationCoordinate2D, error: NSError?, address: String) {
        let mkAnnotation = MKPointAnnotation()
        mkAnnotation.coordinate = coordinates
        mkAnnotation.title = address
        self.myMapView.addAnnotation(mkAnnotation)
        myMapView.setCenter(coordinates, animated: true)
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
            return pinView
        }
        
        
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

