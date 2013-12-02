//
//  CloudEventSynchronizer.m
//  omniRemind
//
//  Created by WenXuan Cai on 11/14/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "CloudEventSynchronizer.h"
#import "Event+Create.h"
@implementation CloudEventSynchronizer

+ (void)syncEvent:(NSString *)eventTitle startDate:(NSDate *)startDate startTime:(NSDate *)startTime endTime:(NSDate *)endTime at:(NSString*)location myLocationKey:(NSString *)myLocationKey otherLocationKey:(NSString *)otherLocationKey withRepeat:(NSDictionary*)repeatDict
     withReminder:(NSDictionary*)reminder manager:(NSManagedObjectContext *)manager {
    PFObject *event = [PFObject objectWithClassName:EVENT_TABLE];
    event[EVENT_TITLE_KEY] = eventTitle;
    event[EVENT_DATE_KEY] = startDate;
    event[EVENT_FROM_KEY] = startTime;
    event[EVENT_TO_KEY] = endTime;
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [Event storeCloudEventWithEventInfo:eventTitle date:startDate from:startTime to:endTime at:location withRepeat:repeatDict withReminder:reminder myLocationKey:myLocationKey otherLocationKey:otherLocationKey cloudEventId:[event objectId] inManagedObjectContext:manager];
    }];
   
}

+ (PFObject *)getEventLocation:(NSString *)cloudEventId {
    PFQuery *query = [PFQuery queryWithClassName:EVENT_TABLE];
    [query whereKey:@"id" equalTo:cloudEventId];
    PFObject *event = [[query findObjects] lastObject];
    return event;
}

+ (PFObject *)getEventFromId:(NSString *)cloudEventId {
    PFQuery *query = [PFQuery queryWithClassName:EVENT_TABLE];
    return [query getObjectWithId:cloudEventId];
}

@end
