//
//  OmniRemindCourse.h
//  omniRemind
//
//  Created by Mira Chen on 11/25/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OmniRemindCourse : NSObject
@property (strong,nonatomic) NSString *courseInstructor;
@property (strong,nonatomic) NSString *courseName;
@property (strong,nonatomic) NSString *courseTitle;
@property (strong,nonatomic) NSString *courseDescription;
@property (nonatomic) int courseCrn;

- (id) initWithDefaultValue;
@end
