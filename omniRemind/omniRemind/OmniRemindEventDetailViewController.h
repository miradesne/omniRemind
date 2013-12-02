//
//  OmniRemindEventDetailViewController.h
//  omniRemind
//
//  Created by Mira Chen on 11/8/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import <UIKit/UIKit.h>

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

-(void)call;
@end
