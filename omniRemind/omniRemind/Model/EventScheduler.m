//
//  EventScheduler.m
//  omniRemind
//
//  Created by WenXuan Cai on 11/29/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "EventScheduler.h"

@implementation EventScheduler

+ (void)schduleEvent:(NSDictionary *)eventInfo {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CST"];
    notification.fireDate = (NSDate *)eventInfo[EVENT_DATE_KEY];
    notification.alertBody = eventInfo[EVENT_INFO_KEY];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
