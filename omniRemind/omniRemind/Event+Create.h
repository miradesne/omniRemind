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


@interface Event (Create)
+ (void)storeEventWithEventInfo:(NSString*)eventTitle date:(NSDate*)date from:(NSDate*)time1 to:(NSDate*)time2 at:(NSString*)location withRepeat:(NSDictionary*)repeatDict withReminder:(NSDictionary*)reminder inManagedObjectContext:(NSManagedObjectContext*)context;
@end
