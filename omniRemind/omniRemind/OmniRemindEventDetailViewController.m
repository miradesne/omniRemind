//
//  OmniRemindEventDetailViewController.m
//  omniRemind
//
//  Created by Mira Chen on 11/8/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "OmniRemindEventDetailViewController.h"
#import "OmniRemindDayViewController.h"
@interface OmniRemindEventDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *cloudIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *cloudIdTitle;

@end

@implementation OmniRemindEventDetailViewController


- (void)setEventTitle:(NSString *)eventTitle {
    _eventTitle = eventTitle;
    self.titleLabel.text = eventTitle;
}

- (void)setStartTime:(NSString *)startTime {
    _startTime = startTime;
    self.startTimeLabel.text = startTime;
}

- (void)setEndTime:(NSString *)endTime {
    _endTime = endTime;
    self.endTimeLabel.text = endTime;
}

- (void)setLocation:(NSString *)location {
    _location = location;
    self.locationLabel.text = location;
}

- (void)setCloudId:(NSString *)cloudId {
    _cloudId = cloudId;
    self.cloudIdTitle.text = @"Cloud Event Id";
    self.cloudIdLabel.text = cloudId;
}

@end
