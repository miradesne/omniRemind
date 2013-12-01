//
//  Event+Create.m
//  omniRemind
//
//  Created by Mira Chen on 11/29/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "Event+Create.h"
#import "Repeat+Set.h"

#define LOCATION_KEY_1 @"location1"
#define LOCATION_KEY_2 @"location2"

@implementation Event (Create)
+ (void)storeEventWithEventInfo:(NSString*)eventTitle date:(NSDate*)date from:(NSDate*)time1 to:(NSDate*)time2 at:(NSString*)location withRepeat:(NSDictionary*)repeatDict withReminder:(NSDictionary*)reminder inManagedObjectContext:(NSManagedObjectContext*)context{
    Event *newEvent = nil;
    NSLog(@"%@",context);
    newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
    newEvent.event_title = eventTitle;
    newEvent.event_location = location;
    newEvent.event_date = date;
    newEvent.start_time = time1;
    newEvent.end_time = time2;
    newEvent.remind_time = reminder[REMIND_TIME_KEY];
    newEvent.remind_message = reminder[REMIND_MESSAGE_KEY];
    
    Repeat *repeat = [Repeat repeatWithDictionary:repeatDict inManagedObjectContext:context];
    newEvent.repeat_attribute = repeat;
    

}

+ (void)storeCloudEventWithEventInfo:(NSString*)eventTitle date:(NSDate*)date from:(NSDate*)time1 to:(NSDate*)time2 at:(NSString*)location withRepeat:(NSDictionary*)repeatDict withReminder:(NSDictionary*)reminder myLocationKey:(NSString *)myLocationKey otherLocationKey:(NSString *)otherLocationKey cloudEventId:(NSString *)cloudEventId inManagedObjectContext:(NSManagedObjectContext*)context{
    Event *newEvent = nil;
    NSLog(@"%@",context);
    newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
    newEvent.event_title = eventTitle;
    newEvent.event_location = location;
    newEvent.event_date = date;
    newEvent.start_time = time1;
    newEvent.end_time = time2;
    newEvent.remind_time = reminder[REMIND_TIME_KEY];
    newEvent.remind_message = reminder[REMIND_MESSAGE_KEY];
    newEvent.my_location_key = myLocationKey;
    newEvent.other_location_key = otherLocationKey;
    newEvent.cloud_event_id = cloudEventId;
    
    Repeat *repeat = [Repeat repeatWithDictionary:repeatDict inManagedObjectContext:context];
    newEvent.repeat_attribute = repeat;
    
    
}
@end
