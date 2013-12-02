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

@interface OmniRemindEventDetailViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *cloudIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *cloudIdTitle;
@property (weak, nonatomic) IBOutlet UIButton *showMapBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) OmniRemindDataManager *manager;
@end

@implementation OmniRemindEventDetailViewController

- (void)viewDidLoad {
    self.manager = [[OmniRemindDataManager alloc] init];
    self.titleLabel.text = self.eventTitle;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy"];
    self.dateLabel.text = [formatter stringFromDate:self.date];
    [formatter setDateFormat:@"h:mm:ss a"];
    self.startTimeLabel.text = [formatter stringFromDate:self.startTime];
    self.endTimeLabel.text = [formatter stringFromDate:self.endTime];
    if (self.location) {
        self.locationLabel.text = self.location;
    }
    if (self.cloudId) {
        self.cloudIdLabel.text = self.cloudId;
    } else {
        self.cloudIdTitle.text = @"";
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
            }
        }
    }
}

@end
