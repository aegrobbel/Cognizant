//
//  Incident.swift
//  Cognizant
//
//  Created by Richard Kim on 10/9/16.
//  Copyright © 2016 Richard Kim. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

struct Incident {
    var coord = CLLocationCoordinate2D()
    var hour = Int()
}

class IncidentModel {
    
    var incidentArr = [Incident]()
    
    init(){
        let url = NSBundle.mainBundle().URLForResource("incidents15", withExtension: "json")!
        let data = NSData(contentsOfURL: url)!
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            
            if let crimes = json["crimes"] as? [[String: AnyObject]] {
                for crime in crimes {
                    guard let lat = crime["LAT"] as? Double, let long = crime["LON"] as? Double, let hour = crime["HOUR"] as? Int else {
                        continue
                    }
                    let loc = CLLocation(latitude: lat, longitude: long)
                    var incident = Incident()
                    incident.coord = loc.coordinate
                    incident.hour = hour
                    incidentArr.append(incident)
                }
            }
        } catch {
            print("error serializing JSON: \(error)")
        }
    }
    
    func filterValues(currHour: Int) -> [NSValue : Int] {
        
        let currHour = currHour % 24
        var coords = [NSValue : Int]()

        for i in incidentArr {
            if ((currHour <= (i.hour + 1) % 24) && (currHour >= (i.hour - 1) % 24)) {
                
                let point = MKMapPointForCoordinate(i.coord)
                let pointWrapper = NSValue(MKMapPoint: point)
                let weight = 1
                
                coords[pointWrapper] = weight;
            }
        }
        return coords
    }
}
