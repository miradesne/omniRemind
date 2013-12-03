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

#define LOCATION_SYNC_INTERVAL 5.0

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

// Sync with the event, get the other's position, update ours.
- (void)syncLocation {
//    static float l = 38;
//    PFGeoPoint *point = [PFGeoPoint geoPointWithLocation:[[CLLocation alloc] initWithLatitude:l longitude:-122]];
//    l += 0.1;

    PFQuery *query = [PFQuery queryWithClassName:EVENT_TABLE];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:self.cloudEventId block:^(PFObject *event, NSError *error) {
        
        // Now let's update it with some new data. In this case, only cheatMode and score
        // will get sent to the cloud. playerName hasn't changed.
        NSLog(@"UPPP");
//        event[self.otherLocationKey] = point;
        [self updateLocation:event];
        CLLocation *location = self.locationManager.location;
        event[self.myLocationKey] = [PFGeoPoint geoPointWithLocation:[[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude]];
        [event saveInBackground];
    }];
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [_locationManager setDelegate:self];
//        [_locationManager setPurpose:@"Your current location is used to demonstrate PFGeoPoint and Geo Queries."];
    }
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
    else{
        if (self.routeToShow) {
            [self showRoute:self.routeToShow];
        }
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
        UIImage *image = [UIImage imageNamed:@"Circle_Yellow.png"];
        // Scale to fit.
        view.image = [UIImage imageWithCGImage:[image CGImage] scale:image.scale * 8 orientation:image.imageOrientation];
    }
    return view;
}

- (void)updateLocation:(PFObject *)object {
    PFGeoPoint *geoPoint = object[self.otherLocationKey];
    NSLog(@"other %@ %@", [NSNumber numberWithDouble:geoPoint.latitude], [NSNumber numberWithDouble:geoPoint.longitude]);
    NSLog(@"my %@", self.locationManager.location);
    GeoPointAnnotation *geoPointAnnotation = [[GeoPointAnnotation alloc] initWithGeoPoint:geoPoint];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:geoPointAnnotation];
}

- (void)showRoute:(MKRoute *)route
{

    [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
    
    for (MKRouteStep *step in route.steps)
    {
        NSLog(@"%@", step.instructions);
    }
    MKRouteStep *lastStep = [route.steps lastObject];
    MKPointAnnotation *pin = [[MKPointAnnotation alloc]init];
    pin.coordinate = lastStep.polyline.coordinate ;
    [self.mapView addAnnotation:pin];
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 7.0;
    return renderer;
}


@end
