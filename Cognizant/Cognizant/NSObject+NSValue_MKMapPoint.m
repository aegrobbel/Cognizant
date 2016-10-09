//
//  NSObject+NSValue_MKMapPoint.m
//  Cognizant
//
//  Created by Richard Kim on 10/9/16.
//  Copyright © 2016 Richard Kim. All rights reserved.
//

#import "NSObject+NSValue_MKMapPoint.h"

@implementation NSValue (MKMapPoint)

+ (NSValue *)valueWithMKMapPoint:(MKMapPoint)mapPoint {
    return [NSValue value:&mapPoint withObjCType:@encode(MKMapPoint)];
}

- (MKMapPoint)MKMapPointValue {
    MKMapPoint mapPoint;
    [self getValue:&mapPoint];
    return mapPoint;
}

@end
