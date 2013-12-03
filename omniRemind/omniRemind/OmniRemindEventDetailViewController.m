//
//  OmniRemindEventDetailViewController.m
//  omniRemind
//
//  Created by Mira Chen on 11/8/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "OmniRemindEventDetailViewController.h"
#import "OmniRemindDayViewController.h"
#import "OmniRemindMapViewController.h"
#import "OmniRemindDataManager.h"
#import "MapNavigator.h"
@interface OmniRemindEventDetailViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *cloudIdTitle;
@property (weak, nonatomic) IBOutlet UIButton *showMapBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *cloudIdLabel;
@property (strong, nonatomic) OmniRemindDataManager *manager;
@property (weak, nonatomic) IBOutlet UILabel *estimatedTimeLabel;
@property (strong, nonatomic) MKRoute *routeToShow;
@end

@implementation OmniRemindEventDetailViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotRoute:)
                                                 name:@"routeLoad"
                                               object:nil];
}

- (void) gotRoute:(NSNotification *) notification {
    
    NSLog(@"got the route %@",notification.userInfo);
    self.routeToShow = notification.userInfo[@"route"];
    if (self.routeToShow) {
        float time = self.routeToShow.expectedTravelTime;
        int hour = floor(time / 3600.0);
        int minute = floor(time/60.0 - hour*60.0);
        if (hour > 0) {
            self.estimatedTimeLabel.text = [NSString stringWithFormat:@"( %d hours %d mins )",hour,minute];
        }
        else if (minute > 0){
            self.estimatedTimeLabel.text = [NSString stringWithFormat:@"( %d mins )",minute];
        }
        [self.estimatedTimeLabel sizeToFit];

    }
}

- (void)viewDidLoad {
    [self setup];
    
}

- (void)viewWillAppear:(BOOL)animated{
    if (self.location.length > 0) {
        self.locationLabel.text = self.location;
        
        MapNavigator *navigator = [[MapNavigator alloc]init];
        MKRoute *route = [navigator getRouteFromLocation:self.location];
        
    }
}



- (IBAction)removeEvent:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Remove Event" message:@"Are you sure to remove this event?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes", @"No", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // Yes. Remove.
        [self.manager removeEvent:self.oid];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        if ([segue.identifier isEqualToString:@"showMap"]) {
            if ([segue.destinationViewController isKindOfClass:[OmniRemindMapViewController class]]) {
                OmniRemindMapViewController *mvc = (OmniRemindMapViewController *)segue.destinationViewController;
                mvc.myLocationKey = self.myLocationKey;
                mvc.otherLocationKey = self.otherLocationKey;
                mvc.cloudEventId = self.cloudId;
                if (self.routeToShow) {
                    mvc.routeToShow = self.routeToShow;
                }
            }
        }
    }
}

- (void)setup{
    self.manager = [[OmniRemindDataManager alloc] init];
    self.titleLabel.text = self.eventTitle;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    self.dateLabel.text = [formatter stringFromDate:self.date];
    [formatter setDateFormat:@"h:mm:ss a"];
    self.startTimeLabel.text = [formatter stringFromDate:self.startTime];
    self.endTimeLabel.text = [formatter stringFromDate:self.endTime];
    
    if (self.cloudId) {
        self.cloudIdLabel.text = self.cloudId;
    } else {
        self.cloudIdTitle.text = @"";
    }
}

@end
