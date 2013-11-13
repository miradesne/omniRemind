//
//  CourseDataFetcher.h
//  omniRemind
//
//  Created by WenXuan Cai on 11/12/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

// All table name
#define COURSE_TABLE @"Course"
#define EXAM_TABLE @"Exam"
#define ASSIGNMENT_TABLE @"Assignment"

// The course table.
#define INSTRUCTOR_KEY @"instructor"
#define CRN_KEY @"crn"
#define COURSE_NAME_KEY @"courseName"
#define COURSE_TITLE_KEY @"courseTitle"
#define COURSE_DESCRIPTION_KEY @"courseDescription"

// The exam table.
#define EXAM_NAME_KEY @"examName"
#define EXAM_TYPE_KEY @"examType"
#define DUE_DATE_KEY @"due"

// The assignment table.
#define ASSIGNMENT_NAME_KEY @"name"
#define ASSIGNMENT_DUE_DATE_KEY @"due"
#define ASSIGNMENT_DESCRIPTION @"assignmentDescription"

@interface CourseDataFetcher : NSObject

+ (PFObject *)fetchCourse:(NSString *)courseName;
+ (NSArray *)fetchAssignments:(PFObject *)course;
+ (NSArray *)fetchExams:(PFObject *)course;

@end
