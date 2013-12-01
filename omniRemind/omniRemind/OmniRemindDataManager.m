//
//  OmniRemindDataManager.m
//  omniRemind
//
//  Created by Mira Chen on 11/29/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "OmniRemindDataManager.h"
#import "CourseDataFetcher.h"
#import "Repeat+Set.h"
#import "Event+Create.h"



@interface OmniRemindDataManager ()
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@end
@implementation OmniRemindDataManager
- (id)init{
    static OmniRemindDataManager *manager;

    if (!manager) {
        manager = [super init];
        [self constructDatabase];
    }
    return manager;
}

//- (NSManagedObjectContext*)managedObjectContext{
//    if (!_managedObjectContext) {
//        [self constructDatabase];
//        
//    }
//    return _managedObjectContext;
//}



- (void)storeEventWithTitle:(NSString*)eventTitle date:(NSString*)date from:(NSString*)time1 to:(NSString*)time2 at:(NSString*)location withRepeat:(NSDictionary*)repeatDict withReminder:(NSDictionary*)reminder{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateToPut = [dateFormat dateFromString:date];
    [dateFormat setDateFormat:@"h:mm a"];
    NSDate *startTime = [dateFormat dateFromString:time1];
    NSDate *endTime = [dateFormat dateFromString:time2];
    [Event storeEventWithEventInfo:eventTitle date:dateToPut from:startTime to:endTime at:location withRepeat:repeatDict withReminder:reminder inManagedObjectContext:self.managedObjectContext];
}


- (void)storeCourse:(PFObject*)course{
    NSArray *assignments = [CourseDataFetcher fetchAssignments:course];
    NSArray *exams = [CourseDataFetcher fetchExams:course];
    for (PFObject *assignment in assignments) {
        if (assignment) {
            [self storeAssignment:assignment];
        }
    }
    
    for (PFObject *exam in exams) {
        if (exam) {
            [self storeExam:exam];
        }
    }
}

- (void)storeAssignment:(PFObject*)assignment{
    NSString *assignmentName = assignment[ASSIGNMENT_NAME_KEY];
    NSDate *endTime = assignment[ASSIGNMENT_DUE_DATE_KEY];
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    NSString *formattedAssignmentDue = [assignmentDue substringToIndex:assignmentDue.length-5];
//    NSLog(@"%@",formattedAssignmentDue);
//    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit) fromDate:endTime];
    [comp setMinute:comp.minute - 15];
    NSDate *startTime = [calendar dateFromComponents:comp];
    NSDictionary *reminder = @{REMIND_TIME_KEY: startTime,REMIND_MESSAGE_KEY: assignmentName};
    
    [Event storeEventWithEventInfo:assignmentName date:endTime from:startTime to:endTime at:nil withRepeat:nil withReminder:reminder inManagedObjectContext:self.managedObjectContext];
    
}

- (void)storeExam:(PFObject*)exam{
    
}


-(void)constructDatabase{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"another"];
    UIManagedDocument *document = [[UIManagedDocument alloc]initWithFileURL:url];
    if(![[NSFileManager defaultManager]fileExistsAtPath:[url path]]){
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            if (success){
                NSLog(@"successfully print");
                self.managedObjectContext = document.managedObjectContext;
            }
            else{
                NSLog(@"fail..");
            }
        }];
    }else if (document.documentState==UIDocumentStateClosed){
        NSLog(@"closed!");
        
        
        [document openWithCompletionHandler:^(BOOL success){
            
            if(success){
                NSLog(@"mirasuccess");
                self.managedObjectContext = document.managedObjectContext;
            }
            else{
                NSLog(@"cannot open it");
            }
        }];
    }else{
        self.managedObjectContext = document.managedObjectContext;
    }
}

@end
