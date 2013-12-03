//
//  MapNavigator.h
//  omniRemind
//
//  Created by Mira Chen on 12/3/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface MapNavigator : NSObject
- (void)getRouteFromLocation:(NSString*)location;

@end
