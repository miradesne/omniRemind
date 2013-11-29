//
//  GeoPointAnnotation.m
//  omniRemind
//
//  Created by WenXuan Cai on 11/13/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "GeoPointAnnotation.h"

@interface GeoPointAnnotation()
@property (nonatomic, strong) PFGeoPoint *geoPoint;
@end

@implementation GeoPointAnnotation


#pragma mark - Initialization

- (id)initWithGeoPoint:(PFGeoPoint *)geoPoint {
    self = [super init];
    if (self) {
        [self setGeoPoint:geoPoint];
    }
    return self;
}


#pragma mark - MKAnnotation

// Called when the annotation is dragged and dropped. We update the geoPoint with the new coordinates.
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
    [self setGeoPoint:geoPoint];
}


#pragma mark - ()


- (void)setGeoPoint:(PFGeoPoint *)geoPoint {
    _coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
}

@end