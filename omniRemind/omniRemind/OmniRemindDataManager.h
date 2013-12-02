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

- (void)storeEventWithTitle:(NSString*)eventTitle date:(NSString*)date from:(NSString*)time1 to:(NSString*)time2 at:(NSString*)location withRepeat:(NSDictionary*)repeatDict withReminder:(NSDictionary*)reminder;

- (void)storeCloudEventWithTitle:(NSString*)eventTitle date:(NSString*)date from:(NSString*)time1 to:(NSString*)time2 at:(NSString*)location myLocationKey:(NSString *)myLocationKey otherLocationKey:(NSString *)otherLocationKey withRepeat:(NSDictionary*)repeatDict cloudId:(NSString *)cloudId
                    withReminder:(NSDictionary*)reminder;
@end
