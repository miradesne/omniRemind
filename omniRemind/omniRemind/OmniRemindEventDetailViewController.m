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

@interface OmniRemindEventDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *cloudIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *cloudIdTitle;
@property (weak, nonatomic) IBOutlet UIButton *showMapBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation OmniRemindEventDetailViewController

- (void)call {
    NSLog(@"calll");
}

- (void)viewDidLoad {
    self.titleLabel.text = self.eventTitle;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH-mm-ss"];
    self.dateLabel.text = [formatter stringFromDate:self.date];
    self.startTimeLabel.text = [formatter stringFromDate:self.startTime];
    self.endTimeLabel.text = [formatter stringFromDate:self.endTime];
    if (self.location) {
        self.locationLabel.text = self.location;
    }
    if (self.cloudId) {
        self.cloudIdLabel.text = self.cloudId;
            self.cloudIdTitle.text = @"Cloud Event Id";
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
