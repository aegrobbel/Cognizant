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
            view.leadingAnchor.constraintEqualToAnchor(mapView.leadingAnchor)!,
            view.trailingAnchor.constraintEqualToAnchor(mapView.trailingAnchor)!,
            view.topAnchor.constraintEqualToAnchor(mapView.topAnchor)!,
            view.bottomAnchor.constraintEqualToAnchor(mapView.bottomAnchor)!
        ]
        
        NSLayoutConstraint.activateConstraints(constraints)
        
        let button = UIBarButtonItem(title: "Re-Center", style: .Plain, target: self, action: #selector(reCenter))
        toolbarItems = [ button ]
    
    }

    func reCenter() {
        let userLocation = mapView.userLocation
        
        let region = MKCoordinateRegionMakeWithDistance(
            userLocation.location!.coordinate, 500, 500)
        
        mapView.setRegion(region, animated: true)
    }
}
