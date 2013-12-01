//
//  Event+Create.h
//  omniRemind
//
//  Created by Mira Chen on 11/29/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "Event.h"

#define REMIND_TIME_KEY @"remindTime"
#define REMIND_MESSAGE_KEY @"remindMessage"
#define EVENT_START_TIME_KEY @"start_time"

@interface Event (Create)

// Save a local event.
+ (void)storeEventWithEventInfo:(NSString*)eventTitle date:(NSDate*)date from:(NSDate*)time1 to:(NSDate*)time2 at:(NSString*)location withRepeat:(NSDictionary*)repeatDict withReminder:(NSDictionary*)reminder inManagedObjectContext:(NSManagedObjectContext*)context;

// Save a cloud event.
+ (void)storeCloudEventWithEventInfo:(NSString*)eventTitle date:(NSDate*)date from:(NSDate*)time1 to:(NSDate*)time2 at:(NSString*)location withRepeat:(NSDictionary*)repeatDict withReminder:(NSDictionary*)reminder myLocationKey:(NSString *)myLocationKey otherLocationKey:(NSString *)otherLocationKey cloudEventId:(NSString *)cloudEventId inManagedObjectContext:(NSManagedObjectContext*)context;

@end
