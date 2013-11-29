//
//  Event.h
//  omniRemind
//
//  Created by Mira Chen on 11/29/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Repeat;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * end_time;
@property (nonatomic, retain) NSString * event_detail;
@property (nonatomic, retain) NSString * event_location;
@property (nonatomic, retain) NSString * event_title;
@property (nonatomic, retain) NSDate * remind_time;
@property (nonatomic, retain) NSString * remind_message;
@property (nonatomic, retain) NSDate * start_time;
@property (nonatomic, retain) NSDate * event_date;
@property (nonatomic, retain) Repeat *repeat_attribute;

@end
