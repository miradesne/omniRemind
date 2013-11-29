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
@end
