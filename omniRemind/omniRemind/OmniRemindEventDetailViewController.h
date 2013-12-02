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
@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSString *endTime;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *cloudId;

@end
