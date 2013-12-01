//
//  Repeat+Set.m
//  omniRemind
//
//  Created by Mira Chen on 11/29/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "Repeat+Set.h"

#define REPEAT_BY_KEY @"repeatBy"
#define REPEAT_END_KEY @"repeatEnd"
#define REPEAT_START_KEY @"repeatStart"
#define REPEAT_TYPE_KEY @"repeatType"
@implementation Repeat (Set)
+ (Repeat *)repeatWithDictionary:(NSDictionary*)repeatDict inManagedObjectContext:(NSManagedObjectContext*)context{
    Repeat *repeat = nil;
    if (repeat) {
        repeat = [NSEntityDescription insertNewObjectForEntityForName:@"Repeat" inManagedObjectContext:context];
        repeat.repeat_by = repeatDict[REPEAT_BY_KEY];
        repeat.repeat_end = repeatDict[REPEAT_START_KEY];
        repeat.repeat_start = repeatDict[REPEAT_END_KEY];
        repeat.repeat_type = repeatDict[REPEAT_BY_KEY];
        
    }
    
    return repeat;
}
@end
