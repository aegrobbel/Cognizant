//
//  NSObject+NSValue_MKMapPoint.h
//  Cognizant
//
//  Created by Richard Kim on 10/9/16.
//  Copyright © 2016 Richard Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface NSValue (MKMapPoint)

+ (NSValue *)valueWithMKMapPoint:(MKMapPoint)mapPoint;
- (MKMapPoint)MKMapPointValue;

@end

