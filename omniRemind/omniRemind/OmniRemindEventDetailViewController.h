//
//  OmniRemindEventDetailViewController.h
//  omniRemind
//
//  Created by Mira Chen on 11/8/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//
//  The event detail view shows the information of the event
//  If the location is not empty, it will call the map navigator class
//  to calculate the estimated travel time and navigation routes
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface OmniRemindEventDetailViewController : UIViewController

@property (strong, nonatomic) NSString *eventTitle;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) NSString *location;
// Set these two when setting the event id.
@property (strong, nonatomic) NSString *cloudId;
@property (strong, nonatomic) NSString *myLocationKey;
@property (strong, nonatomic) NSString *otherLocationKey;
@property (strong, nonatomic) NSManagedObjectID *oid;


@end
