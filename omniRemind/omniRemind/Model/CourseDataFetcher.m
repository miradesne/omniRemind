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
    // Make sure the course name has the right format to query.
    courseName = [self fixCourseName:courseName];
    PFQuery *query = [PFQuery queryWithClassName:COURSE_TABLE];
    [query whereKey:COURSE_TITLE_KEY equalTo:courseName];
    NSArray *courses = [query findObjects];
    if (!courses || [courses count] == 0 || [courses count] > 1) {
        // Error. Bad course name?
        return nil;
    } else {
        return [courses lastObject];
    }
}

+ (void)createAssignment:(PFObject *)course {
    PFObject *assignment = [PFObject objectWithClassName:ASSIGNMENT_TABLE];
    assignment[ASSIGNMENT_NAME_KEY] = @"HW8";
    // Add a relation between the Post and Comment
    assignment[@"course"] = course;
    // This will save both myPost and myComment
    [assignment saveInBackground];
}

+ (NSArray *)fetchAssignments:(PFObject *)course {
    PFQuery *query = [PFQuery queryWithClassName:ASSIGNMENT_TABLE];
    [query whereKey:@"course" equalTo:course];
    NSArray *result = [query findObjects];
    if ([result count]) {
        for (PFObject *assignment in result) {
            NSDate *date = assignment[ASSIGNMENT_DUE_DATE_KEY];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *comp = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
            [comp setHour:comp.hour + 6];
            assignment[ASSIGNMENT_DUE_DATE_KEY] = [calendar dateFromComponents:comp];
        }
    }
    return result;
}

+ (NSArray *)fetchExams:(PFObject *)course {
    PFQuery *query = [PFQuery queryWithClassName:EXAM_TABLE];
    [query whereKey:@"course" equalTo:course];
    return [query findObjects];
}

+ (NSString *)fixCourseName:(NSString *)course {
    return [course uppercaseString];
}

@end
