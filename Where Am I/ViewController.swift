//
//  ViewController.swift
//  Where Am I
//
//  Created by David Rollins on 11/9/15.
//  Copyright © 2015 David Rollins. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// page that shows displays users latitide and longitude
// and course speed and altitude
// get the nearest address - from the location - reverseGeoCodeLocation
//
//


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var lblCourse: UILabel!
    @IBOutlet weak var lblSpeed: UILabel!
    @IBOutlet weak var lblAltitude: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblLatitude.text = ""
        lblLongitude.text = ""
        lblCourse.text = ""
        lblSpeed.text = ""
        lblAltitude.text = ""
        lblAddress.text = ""
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        // will alert us any time location changes assuming user gives permission
        locationManager.startUpdatingLocation()
        
        let latititude:CLLocationDegrees = -33.856375
        let longitude:CLLocationDegrees = 151.206751
        
        //delta = the different in lat or long from one side of the map to the other
        // the smaller the number the more you are zoomed in
        // 1 =  very zoomed out
        // 0.00001 - very zoomed in
        
        let latDelta: CLLocationDegrees = 0.01
        let lonDelta: CLLocationDegrees = 0.01
        
        let span:MKCoordinateSpan =  MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latititude, longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        map.setRegion(region, animated: true)
        map.showsUserLocation = true

    }
    
    // method called every time a new location is registerd by CoreLocation locationManager object above
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations)
        
        var userLocation:CLLocation = locations[0]
        
        var latitude = userLocation.coordinate.latitude
        var longitude = userLocation.coordinate.longitude
        
        
        let latDelta: CLLocationDegrees = 0.01
        let lonDelta: CLLocationDegrees = 0.01
        
        
        let span:MKCoordinateSpan =  MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        self.map.setRegion(region, animated: true)
        
        lblLatitude.text = "\(latitude)"
        lblLongitude.text = "\(longitude)"
        lblCourse.text = "\(userLocation.course)"
        lblSpeed.text = "\(userLocation.speed)"
        lblAltitude.text = "\(userLocation.altitude)"
        
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: {(placemarks, error) -> Void in
            print(location)
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if error == nil {
                
                
                if let placemark = placemarks!.last! as? CLPlacemark {
                    
//                    var subThoroughfare = ""
//                    
//                    if placemark.subThoroughfare != nil{
//                        subThoroughfare = placemark.subThoroughfare!
//                    }
                    
                    if let addrList = placemark.addressDictionary!["FormattedAddressLines"] as? [String] {
                        var addr = ""
                        for a in addrList {
                            if addr.characters.count > 0 {
                                addr = addr + "\n"
                            }
                            
                            addr = addr + a
                        }
                        self.lblAddress.text = addr
                    }
                }
            }
        })
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

