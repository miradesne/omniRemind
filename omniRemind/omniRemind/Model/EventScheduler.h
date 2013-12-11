//
//  EventScheduler.h
//  omniRemind
//
//    API to set the LocationNotifcation for an event
//
//  Created by WenXuan Cai on 11/29/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EVENT_DATE_KEY @"date"
#define EVENT_INFO_KEY @"info"
#define EVENT_REPEAT_KEY @"repeat"
#define EVENT_REMIND_KEY @"remind"

@interface EventScheduler : NSObject


+ (void)schduleEvent:(NSDictionary *)eventInfo;


@end
