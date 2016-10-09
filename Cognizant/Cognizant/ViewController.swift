//
//  ViewController.swift
//  Cognizant
//
//  Created by Richard Kim on 10/8/16.
//  Copyright © 2016 Richard Kim. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    let mapView = MKMapView()
    var locationManager: CLLocationManager?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        reCenter()
    }

    override func loadView() {
        
        self.view = UIView();
        self.view.backgroundColor = UIColor.darkGrayColor()
        self.view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserLocation = true
        locationManager = CLLocationManager()
        locationManager!.requestWhenInUseAuthorization()
        
        let constraints = [
            view.leadingAnchor.constraintEqualToAnchor(mapView.leadingAnchor),
            view.trailingAnchor.constraintEqualToAnchor(mapView.trailingAnchor),
            view.topAnchor.constraintEqualToAnchor(mapView.topAnchor),
            view.bottomAnchor.constraintEqualToAnchor(mapView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activateConstraints(constraints)
        
        let button = UIBarButtonItem(title: "Re-Center", style: .Plain, target: self, action: #selector(reCenter))
        toolbarItems = [ button ]
    
    }
    func parseData() -> [NSValue : Int] {
        let url = NSBundle.mainBundle().URLForResource("incidents15", withExtension: "json")!
        let data = NSData(contentsOfURL: url)!
        
        var coords = [NSValue : Int]()
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            if let crimes = json["crimes"] as? [[String: AnyObject]] {
                for crime in crimes {
                    guard let lat = crime["LAT"] as? Double, let long = crime["LON"] as? Double, let hour = crime["HOUR"] as? Int else {
                        continue
                    }
                    
                    let loc = CLLocation(latitude: lat, longitude: long)
                    let point = MKMapPointForCoordinate(loc.coordinate)
                    let weight = 1
                    let pointWrapper = NSValue(MKMapPoint: point)
                    coords[pointWrapper] = weight
                    
                }
            }
        } catch {
            print("error serializing JSON: \(error)")
        }
        return coords
    }
    
    func reCenter() {
        let userLocation = mapView.userLocation
        
        let region = MKCoordinateRegionMakeWithDistance(
            userLocation.location!.coordinate, 500, 500)
        
        mapView.setRegion(region, animated: true)
    }

    
}

