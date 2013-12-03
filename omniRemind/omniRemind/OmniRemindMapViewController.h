//
//  OmniRemindMapViewController.h
//  omniRemind
//
//  Created by WenXuan Cai on 11/13/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface OmniRemindMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) NSString *myLocationKey;
@property (strong, nonatomic) NSString *otherLocationKey;
@property (strong, nonatomic) NSString *cloudEventId;

@property (strong, nonatomic) MKRoute *routeToShow;
@end
