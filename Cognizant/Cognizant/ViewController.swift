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
    
    var currHour = 0 {
        didSet {
            if oldValue != currHour {
                updateHeatmap()
            }
        }
    }
    
    let incident = IncidentModel()
    let heatMap = DTMHeatmap()
    
    let mapView = MKMapView()
    let slider = UISlider()
    
    let formatter = NSDateFormatter()
    
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
        
        currHour = Int(round(slider.value)) % 24
    }
    
    func updateHeatmap() {
        heatMap.setData(incident.filterValues(currHour))
        mapView.rendererForOverlay(heatMap)?.setNeedsDisplay()
        
        if let date = NSCalendar.currentCalendar().dateBySettingUnit(.Hour, value: currHour, ofDate: NSDate(), options: []) {
            navigationItem.title = formatter.stringFromDate(date)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        sliderButton.width = view.bounds.width - 30
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.setLocalizedDateFormatFromTemplate("h aa")
        
        let date = NSDate()
        currHour = NSCalendar.currentCalendar().component(.Hour, fromDate: date)
        slider.value = Float(currHour)
        
        mapView.addOverlay(heatMap)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        return DTMHeatmapRenderer.init(overlay: overlay)
    }

    func reCenter() {
        let userLocation = mapView.userLocation
        
        let region = MKCoordinateRegionMakeWithDistance(
            userLocation.location!.coordinate, 500, 500)
        
        mapView.setRegion(region, animated: true)
    }
}
