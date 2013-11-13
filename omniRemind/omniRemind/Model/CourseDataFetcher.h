//
//  CourseDataFetcher.h
//  omniRemind
//
//  Created by WenXuan Cai on 11/12/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface CourseDataFetcher : NSObject

+ (PFObject *)fetchCourse:(NSString *)courseName;
+ (NSArray *)fetchAssignments:(PFObject *)course;
+ (NSArray *)fetchExams:(PFObject *)course;

@end
