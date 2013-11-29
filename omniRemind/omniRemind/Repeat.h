//
//  Repeat.h
//  omniRemind
//
//  Created by Mira Chen on 11/29/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Repeat : NSManagedObject

@property (nonatomic, retain) NSNumber * repeat_by;
@property (nonatomic, retain) NSDate * repeat_end;
@property (nonatomic, retain) NSDate * repeat_start;
@property (nonatomic, retain) NSNumber * repeat_type;
@property (nonatomic, retain) Event *repeated;

@end
