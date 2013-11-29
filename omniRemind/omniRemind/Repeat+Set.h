//
//  Repeat+Set.h
//  omniRemind
//
//  Created by Mira Chen on 11/29/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "Repeat.h"

@interface Repeat (Set)
+ (Repeat *)repeatWithDictionary:(NSDictionary*)repeatDict inManagedObjectContext:(NSManagedObjectContext*)context;
@end
