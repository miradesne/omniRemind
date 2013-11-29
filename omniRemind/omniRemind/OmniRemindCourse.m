//
//  OmniRemindCourse.m
//  omniRemind
//
//  Created by Mira Chen on 11/25/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "OmniRemindCourse.h"
#import "CourseDataFetcher.h"
@implementation OmniRemindCourse
- (id) initWithDefaultValue{
    self = [super init];
    
    if (self) {
        self.courseCrn = @"18139";
        self.courseDescription = @"As connected smartphones and tablets such as the iPhone and iPad become more popular, updated programming models and design concepts are required to take advantage of their capabilities. COMP/ELEC 446 will consider programming models including natively running applications, web services and mobile tailored web pages. We will explore applications primarily on the Apple iPhone, iPod and iPad but will briefly cover Google Android and Microsoft Windows Phone. We will also briefly touch on the development of web services to support mobile applications. The course culminates with a large project taking up most of the second half of the semester. Curriculum centers around and teaches iOS and code (iPhone/iPad); however final projects may also be completed in any major mobile system if the student has a foundation in Eclipse (Android) or Visual Studio (WP).";
        self.courseInstructor = @"Scott Cutler";
        self.courseName = @"Comp 446";
        self.courseTitle = @"Mobile Device Application";
    }
    return self;
}


- (id) initWithFetchedCourse:(PFObject*)course{
    self = [super init];
    if (self) {
        self.courseName = course[COURSE_NAME_KEY];
        self.courseCrn = course[CRN_KEY];
        self.courseDescription = course[COURSE_DESCRIPTION_KEY];
        self.courseInstructor = course[INSTRUCTOR_KEY];
        self.courseTitle = course[COURSE_TITLE_KEY];

    }
    return self;
    
}
@end
