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

class ViewController: UIViewController, MKMapViewDelegate {
    
    let mapView = MKMapView()
    let slider = UISlider()
    
    var locationManager: CLLocationManager?
    
    let sliderButton = UIBarButtonItem()
    
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
        mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager!.requestWhenInUseAuthorization()
        
        let constraints = [
            view.leadingAnchor.constraintEqualToAnchor(mapView.leadingAnchor),
            view.trailingAnchor.constraintEqualToAnchor(mapView.trailingAnchor),
            view.topAnchor.constraintEqualToAnchor(mapView.topAnchor),
            view.bottomAnchor.constraintEqualToAnchor(mapView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activateConstraints(constraints)
        
        slider.minimumValue = 0
        slider.maximumValue = 24
        slider.addTarget(self, action: #selector(sliderChanged), forControlEvents: .ValueChanged)
        sliderButton.customView = slider
        toolbarItems = [sliderButton]
        
        let button = UIBarButtonItem(title: "Re-Center", style: .Plain, target: self, action: #selector(reCenter))
        navigationItem.rightBarButtonItem = button
        
    }
    
    func sliderChanged() {
        print(slider.value)
    }
    
    override func viewDidLayoutSubviews() {
        sliderButton.width = view.bounds.width - 30
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = NSDate()
        let hour = NSCalendar.currentCalendar().component(.Hour, fromDate: date)
        slider.value = Float(hour)
        
        let data = parseData()
        let heatMap = DTMHeatmap()
        heatMap.setData(data)
        mapView.addOverlay(heatMap)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        return DTMHeatmapRenderer.init(overlay: overlay)
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

