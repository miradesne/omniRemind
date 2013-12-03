//
//  OmniRemindDirectionViewController.m
//  omniRemind
//
//  Created by Mira Chen on 12/3/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "OmniRemindDirectionViewController.h"

@interface OmniRemindDirectionViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@end

@implementation OmniRemindDirectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self test];
    

}


- (CLGeocoder*)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
    
    }
    
    return _geocoder;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        
    }
    return _locationManager;
}


- (void)test{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = [MKMapItem mapItemForCurrentLocation];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self.locationManager startUpdatingLocation];
    [self.geocoder geocodeAddressString:@"5100 Maple StBellaire, TX 77401" completionHandler:^(NSArray* placemarks, NSError* error){
        if (error) {
            NSLog(@"No!! direction Error!");
        }
        MKMapItem *destination;
        for (CLPlacemark* aPlacemark in placemarks)
        {
            // Process the placemark.
            MKPlacemark *placemark = [[MKPlacemark alloc]initWithPlacemark:aPlacemark];
            [self.mapView addAnnotation:placemark];
            [self zoomInToMyLocation:aPlacemark];
             destination = [[MKMapItem alloc]initWithPlacemark:placemark];
            
            
        }
        
        request.destination = destination;
        request.requestsAlternateRoutes = NO;
        MKDirections *directions =
        [[MKDirections alloc] initWithRequest:request];
        
        [directions calculateDirectionsWithCompletionHandler:
         ^(MKDirectionsResponse *response, NSError *error) {
             if (error) {
                 // Handle Error
             } else {
                 NSLog(@"%@",directions);
                 NSLog(@"%@",response);
                 NSLog(@"%@",response.routes);
                 NSTimeInterval traveledTime = 0;
                 [self showRoute:response];
                 for (MKRoute *route in response.routes) {
                     traveledTime += route.expectedTravelTime;
                 }
                 NSLog(@"time %f",traveledTime);
                 
             }
         }];
    }];
    
}


-(void)zoomInToMyLocation:(CLPlacemark*)placemark
{
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = placemark.location.coordinate.latitude ;
    region.center.longitude = placemark.location.coordinate.longitude;
    region.span.longitudeDelta = 1.15f;
    region.span.latitudeDelta = 1.15f;
    [self.mapView setRegion:region animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations lastObject];
    self.currentLocation = [locations lastObject];
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    pin.coordinate = currentLocation.coordinate;
    
    NSLog(@"Mira place %@",pin);
    [self.mapView addAnnotation:pin];
}


- (void)showRoute:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes)
    {
        [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        
        for (MKRouteStep *step in route.steps)
        {
            NSLog(@"%@", step.instructions);
        }
    }
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
