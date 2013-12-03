//
//  OmniRemindDataManager.h
//  omniRemind
//
//  Created by Mira Chen on 11/29/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Parse/Parse.h>

@interface OmniRemindDataManager : NSObject
- (void)storeAssignment:(PFObject*)assignment;
- (void)storeCourse:(PFObject*)course;

- (NSArray*)fetchEventsWithDate:(NSDateComponents*)comp;

- (void)removeEvent:(NSManagedObjectID *)oid;

- (void)storeEventWithTitle:(NSString*)eventTitle date:(NSString*)date from:(NSString*)time1 to:(NSString*)time2 at:(NSString*)location withRepeat:(NSDictionary*)repeatDict withRemindDate:(NSDate *)remindDate;

- (void)storeCloudEventWithTitle:(NSString*)eventTitle date:(NSString*)date from:(NSString*)time1 to:(NSString*)time2 at:(NSString*)location myLocationKey:(NSString *)myLocationKey otherLocationKey:(NSString *)otherLocationKey withRepeat:(NSDictionary*)repeatDict cloudId:(NSString *)cloudId
                    withRemindDate:(NSDate *)remindDate;

- (NSArray*)fetchTasksToDo;
@end
