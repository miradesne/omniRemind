//
//  OmniRemindCourse.h
//  omniRemind
//
//  Created by Mira Chen on 11/25/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface OmniRemindCourse : NSObject
@property (strong,nonatomic) NSString *courseInstructor;
@property (strong,nonatomic) NSString *courseName;
@property (strong,nonatomic) NSString *courseTitle;
@property (strong,nonatomic) NSString *courseDescription;
@property (strong,nonatomic) NSString *courseCrn;

- (id) initWithDefaultValue;
- (id) initWithFetchedCourse:(PFObject*)course;

@end
