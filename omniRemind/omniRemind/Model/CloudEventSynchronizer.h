//
//  CloudEventSynchronizer.h
//  omniRemind
//
//  Created by WenXuan Cai on 11/14/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "OmniRemindDataManager.h"

#define EVENT_TABLE @"Event"
#define EVENT_TITLE_KEY @"title"
#define EVENT_DATE_KEY @"date"
#define EVENT_FROM_KEY @"from"
#define EVENT_TO_KEY @"to"


@interface CloudEventSynchronizer : NSObject

+ (PFObject *)getEventFromId:(NSString *)cloudEventId;

+ (void)syncEvent:(NSString *)eventTitle startDate:(NSDate *)startDate startTime:(NSDate *)startTime endTime:(NSDate *)endTime at:(NSString*)location myLocationKey:(NSString *)myLocationKey otherLocationKey:(NSString *)otherLocationKey withRepeat:(NSDictionary*)repeatDict withReminder:(NSDictionary*)reminder manager:(NSManagedObjectContext *)manager;

@end
