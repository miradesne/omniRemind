//
//  MapNavigator.h
//  omniRemind
//
//  Created by Mira Chen on 12/3/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//
//  This class is to calculate the route from the location information
//  that user provide by using Apple Map API
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface MapNavigator : NSObject
- (void)getRouteFromLocation:(NSString*)location;

@end
