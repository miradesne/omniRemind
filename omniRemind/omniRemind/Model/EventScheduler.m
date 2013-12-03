//
//  EventScheduler.m
//  omniRemind
//
//  Created by WenXuan Cai on 11/29/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "EventScheduler.h"
#import "OmniRemindAddReminderViewController.h"

@implementation EventScheduler

+ (void)schduleEvent:(NSDictionary *)eventInfo {
    NSValue *type = eventInfo[EVENT_REMIND_KEY][REMIND_TYPE_KEY];
    if ([@(PUSH_NOTIFICATION) isEqualToValue:type]) {
        NSDate *remindDate = eventInfo[EVENT_DATE_KEY];
        UILocalNotification *notification = [[UILocalNotification alloc] init];
//        notification.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CST"];
        notification.fireDate = remindDate;
        notification.alertBody = eventInfo[EVENT_INFO_KEY];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

@end
