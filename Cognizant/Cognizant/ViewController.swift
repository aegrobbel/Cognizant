//
//  ViewController.swift
//  Cognizant
//
//  Created by Richard Kim on 10/8/16.
//  Copyright © 2016 Richard Kim. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        parseData()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}

