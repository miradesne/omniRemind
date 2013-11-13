//
//  CourseDataFetcher.m
//  omniRemind
//
//  Created by WenXuan Cai on 11/12/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "CourseDataFetcher.h"


@implementation CourseDataFetcher

+ (PFObject *)fetchCourse:(NSString *)courseName {
    PFQuery *query = [PFQuery queryWithClassName:@"Course"];
    [query whereKey:@"courseTitle" equalTo:courseName];
    NSArray *courses = [query findObjects];
    if (!courses || [courses count] == 0 || [courses count] > 1) {
        // Error. Bad course name?
        return nil;
    } else {
        return [courses lastObject];
    }
}

+ (void)createAssignment:(PFObject *)course {
    PFObject *assignment = [PFObject objectWithClassName:@"Assignment"];
    assignment[@"name"] = @"HW8";
    // Add a relation between the Post and Comment
    assignment[@"course"] = course;
    // This will save both myPost and myComment
    [assignment saveInBackground];
}

+ (NSArray *)fetchAssignments:(PFObject *)course {
    PFQuery *query = [PFQuery queryWithClassName:@"Assignment"];
    [query whereKey:@"course" equalTo:course];
    return [query findObjects];
}

+ (NSArray *)fetchExams:(PFObject *)course {
    PFQuery *query = [PFQuery queryWithClassName:@"Exam"];
    [query whereKey:@"course" equalTo:course];
    return [query findObjects];
}

@end
