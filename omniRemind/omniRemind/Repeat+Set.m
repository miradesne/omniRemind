//
//  Repeat+Set.m
//  omniRemind
//
//  Created by Mira Chen on 11/29/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "Repeat+Set.h"

@implementation Repeat (Set)
+ (Repeat *)repeatWithDictionary:(NSDictionary*)repeatDict inManagedObjectContext:(NSManagedObjectContext*)context{
    Repeat *repeat = nil;
    if (repeat) {
        repeat = [NSEntityDescription insertNewObjectForEntityForName:@"Repeat" inManagedObjectContext:context];
        repeat.repeat_by = repeatDict[@"repeatBy"];
        repeat.repeat_end = repeatDict[@"repeatEnd"];
        repeat.repeat_start = repeatDict[@"repeatStart"];
        repeat.repeat_type = repeatDict[@"repeatType"];
        
    }
    
    return repeat;
}
@end
