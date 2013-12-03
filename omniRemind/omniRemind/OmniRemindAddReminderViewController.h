//
//  OmniRemindAddReminderViewController.h
//  omniRemind
//
//  Created by Mira Chen on 11/30/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "OmniRemindInputViewController.h"


#define REMIND_TYPE_KEY @"remindType"
#define REMIND_TIME_KEY @"remindTime"
#define NO_REMINDER 0
#define PUSH_NOTIFICATION 1
#define SMS_NOTIFICATION 2


#define MINUTES_15 0
#define MINUTES_30 1
#define HOUR_BEFORE 2
#define DAY_BEFORE 3
#define WEEK_BEFORE 4


@interface OmniRemindAddReminderViewController : OmniRemindInputViewController<UIActionSheetDelegate>

+ (NSDate *)remindTimeStringToDate:(NSString *)rtime remindDict:(NSDictionary *)remindDict;

@end
