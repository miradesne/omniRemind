//
//  MapNavigator.m
//  omniRemind
//
//  Created by Mira Chen on 12/3/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "MapNavigator.h"
@interface MapNavigator()
@property (strong, nonatomic) CLGeocoder *geocoder;


@end
@implementation MapNavigator
- (CLGeocoder*)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
        
    }
    
    return _geocoder;
}

- (MKRoute*)getRouteFromLocation:(NSString*)location{
    __block MKRoute *fastestRoute;
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = [MKMapItem mapItemForCurrentLocation];
    [self.geocoder geocodeAddressString:location completionHandler:^(NSArray* placemarks, NSError* error){
        if (error) {
            NSLog(@"No!! direction Error!");
        }
        MKMapItem *destination;
        for (CLPlacemark* aPlacemark in placemarks)
        {
            // Process the placemark.
            MKPlacemark *placemark = [[MKPlacemark alloc]initWithPlacemark:aPlacemark];
            destination = [[MKMapItem alloc]initWithPlacemark:placemark];
            
            
        }
        
        request.destination = destination;
        request.requestsAlternateRoutes = YES;
        MKDirections *directions =
        [[MKDirections alloc] initWithRequest:request];
        
        [directions calculateDirectionsWithCompletionHandler:
         ^(MKDirectionsResponse *response, NSError *error) {
             if (error) {
                 // Handle Error
             } else {
                 float minTime = INFINITY;
                 for (MKRoute *route in response.routes) {
                     if (route.expectedTravelTime < minTime) {
                         minTime = route.expectedTravelTime;
                         fastestRoute = route;
                     }
                 }
                 NSLog(@"time %f",minTime);
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"routeLoad" object:self userInfo:@{@"route":fastestRoute}];
                 
             }
         }];
    }];

    
    return fastestRoute;
}
@end
