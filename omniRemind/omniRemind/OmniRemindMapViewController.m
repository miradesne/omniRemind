//
//  OmniRemindMapViewController.m
//  omniRemind
//
//  Created by WenXuan Cai on 11/13/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "OmniRemindMapViewController.h"
#import "CourseDataFetcher.h"
#import <Parse/Parse.h>
#import "GeoPointAnnotation.h"
#import "CloudEventSynchronizer.h"

#define LOCATION_SYNC_INTERVAL 1.0

@interface OmniRemindMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) NSTimer *locationUpdateTimer;
@end


@implementation OmniRemindMapViewController


- (void)setupLocationSyncTimer {
    self.locationUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:LOCATION_SYNC_INTERVAL
                                                                     target:self
                                                                   selector:@selector(syncLocation:)
                                                                   userInfo:nil
                                                                    repeats:YES];
}

- (void)syncLocation:(NSTimer *)timer {
    [self syncLocation];
}

- (void)syncLocation {
    NSLog(@"fuck");
}

- (void)syncLocation2 {
    PFQuery *query = [PFQuery queryWithClassName:EVENT_TABLE];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:self.cloudEventId block:^(PFObject *event, NSError *error) {
        
        // Now let's update it with some new data. In this case, only cheatMode and score
        // will get sent to the cloud. playerName hasn't changed.
        [self updateLocation:event];
        event[self.myLocationKey] = self.locationManager.location;
        [event saveInBackground];
        
    }];
}

- (CLLocationManager *)locationManager {
    if (_locationManager != nil) {
        return _locationManager;
    }
    _locationManager = [[CLLocationManager alloc] init];
//    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [_locationManager setDelegate:self];
//    [_locationManager setPurpose:@"Your current location is used to demonstrate PFGeoPoint and Geo Queries."];
    return _locationManager;
}

- (void)stopLocationUpdateTimer {
    [self.locationUpdateTimer invalidate];
    self.locationUpdateTimer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
    [[self locationManager] startUpdatingLocation];
    if (self.cloudEventId && self.myLocationKey && self.otherLocationKey) {
        [self setupLocationSyncTimer];
    }
}

// Track use self.
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.mapView.userTrackingMode = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopLocationUpdateTimer];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString *reuseId = @"MapViewController";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (!view) {
        view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        view.canShowCallout = NO;
        if ([mapView.delegate respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)]) {
            view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
//        view.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,30,30)];
        UIImage *image = [UIImage imageNamed:@"Circle_Yellow.png"];
        // Scale to fit.
        view.image = [UIImage imageWithCGImage:[image CGImage] scale:image.scale * 8 orientation:image.imageOrientation];
    }
    return view;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = _locationManager.location;
    static float l = 38;
    [self.mapView removeAnnotations:self.mapView.annotations];
    PFGeoPoint *point = [PFGeoPoint geoPointWithLocation:[[CLLocation alloc] initWithLatitude:l longitude:-122]];
    GeoPointAnnotation *gp = [[GeoPointAnnotation alloc] initWithGeoPoint:point];
    [self.mapView addAnnotation:gp];
    l += 0.1;
}

- (void)updateLocation:(PFObject *)object {
    PFGeoPoint *geoPoint = object[self.otherLocationKey];
    GeoPointAnnotation *geoPointAnnotation = [[GeoPointAnnotation alloc] initWithGeoPoint:geoPoint];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:geoPointAnnotation];
}



@end