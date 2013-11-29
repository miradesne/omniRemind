//
//  CloudEventSynchronizer.m
//  omniRemind
//
//  Created by WenXuan Cai on 11/14/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "CloudEventSynchronizer.h"

@implementation CloudEventSynchronizer

+ (void)syncEvent:(NSDictionary *)eventInfo {
    PFObject *event = [PFObject objectWithClassName:EVENT_TABLE];
    event[EVENT_TITLE_KEY] = eventInfo[EVENT_TITLE_KEY];
    event[EVENT_DATE_KEY] = eventInfo[EVENT_DATE_KEY];
    event[EVENT_FROM_KEY] = eventInfo[EVENT_FROM_KEY];
    event[EVENT_TO_KEY] = eventInfo[EVENT_TO_KEY];
    [event saveInBackground];
}

+ (PFObject *)getEventLocation:(NSString *)cloudEventId {
    PFQuery *query = [PFQuery queryWithClassName:EVENT_TABLE];
    [query whereKey:@"id" equalTo:cloudEventId];
    PFObject *event = [[query findObjects] lastObject];
    return event;
}

+ (PFObject *)getEventFromId:(NSString *)cloudEventId {
    PFQuery *query = [PFQuery queryWithClassName:EVENT_TABLE];
    [query whereKey:@"id" equalTo:cloudEventId];
    return [[query findObjects] lastObject];
}

@end
