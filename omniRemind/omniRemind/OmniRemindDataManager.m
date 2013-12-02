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
#import "CloudEventSynchronizer.h"



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

- (void)constructDatabase{
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



#pragma mark - storeEvents

- (void)storeCloudEventWithTitle:(NSString*)eventTitle date:(NSString*)date from:(NSString*)time1 to:(NSString*)time2 at:(NSString*)location myLocationKey:(NSString *)myLocationKey otherLocationKey:(NSString *)otherLocationKey withRepeat:(NSDictionary*)repeatDict cloudId:(NSString *)cloudId
                    withReminder:(NSDictionary*)reminder {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateToPut = [dateFormat dateFromString:date];
    if (!cloudId) {
        [dateFormat setDateFormat:@"yyyy-MM-dd h:mm a"];
        NSString *startTimeString = [date stringByAppendingString:[NSString stringWithFormat:@" %@", time1]];
        NSString *endTimeString = [date stringByAppendingString:[NSString stringWithFormat:@" %@", time2]];
        NSDate *startTime = [dateFormat dateFromString:startTimeString];
        NSDate *endTime = [dateFormat dateFromString:endTimeString];
        [CloudEventSynchronizer syncEvent:eventTitle startDate:dateToPut startTime:startTime endTime:endTime at:location myLocationKey:myLocationKey otherLocationKey:otherLocationKey withRepeat:repeatDict withReminder:reminder manager:self.managedObjectContext];
    } else {
        [dateFormat setDateFormat:@"h:mm a"];
        NSDate *startTime = [dateFormat dateFromString:time1];
        NSDate *endTime = [dateFormat dateFromString:time2];
        [Event storeCloudEventWithEventInfo:eventTitle date:dateToPut from:startTime to:endTime at:location withRepeat:repeatDict withReminder:reminder myLocationKey:myLocationKey otherLocationKey:otherLocationKey cloudEventId:cloudId inManagedObjectContext:self.managedObjectContext];
    }
}

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
//    NSArray *exams = [CourseDataFetcher fetchExams:course];
    for (PFObject *assignment in assignments) {
        if (assignment) {
            [self storeAssignment:assignment];
        }
    }
    
//    for (PFObject *exam in exams) {
//        if (exam) {
//            [self storeExam:exam];
//        }
//    }
}

- (void)storeAssignment:(PFObject*)assignment{
    NSString *assignmentName = assignment[ASSIGNMENT_NAME_KEY];
    id endTime = assignment[ASSIGNMENT_DUE_DATE_KEY];
    NSDate *dueDate;
    if ([endTime isKindOfClass:[NSString class]]) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        NSString *assignmentDue = (NSString*)endTime;
        NSString *formattedAssignmentDue = [endTime substringToIndex:assignmentDue.length];
        NSLog(@"%@",formattedAssignmentDue);
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dueDate = [df dateFromString:assignmentDue];

    }
    else if ([endTime isKindOfClass:[NSDate class]]){
        dueDate = (NSDate*)endTime;
    }
    if (dueDate) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit) fromDate:dueDate];
        [comp setHour:comp.hour - 1];
        NSDate *startTime = [calendar dateFromComponents:comp];
        NSDictionary *reminder = @{REMIND_TIME_KEY: startTime,REMIND_MESSAGE_KEY: assignmentName};
        
        [Event storeEventWithEventInfo:assignmentName date:dueDate from:startTime to:dueDate at:nil withRepeat:nil withReminder:reminder inManagedObjectContext:self.managedObjectContext];

    }
    else{
        NSLog(@"bug!!! didn't get the dueDate");
    }
    
}

- (void)removeEvent:(NSManagedObjectID *)oid {
    NSManagedObject *eventToDelete = [self.managedObjectContext objectWithID:oid];
    [self.managedObjectContext deleteObject:eventToDelete];
}

#pragma mark - fetchEvent

- (NSArray*)fetchEventsWithDate:(NSDateComponents*)comp{
    NSArray *events;
    if (comp) {
        NSCalendar *calender = [NSCalendar currentCalendar];
        [comp setHour:0];
        [comp setMinute:0];
        [comp setSecond:0];
        NSDate *startDate = [calender dateFromComponents:comp];
        NSLog(@"%@",startDate);
        [comp setHour:23];
        [comp setMinute:59];
        [comp setSecond:59];
        NSDate *endDate = [calender dateFromComponents:comp];
        NSLog(@"%@",endDate);
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(event_date >= %@) AND (event_date <= %@)", startDate, endDate];
        NSLog(@"(event_date >= %@) AND (event_date <= %@)", startDate, endDate);
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:EVENT_START_TIME_KEY ascending:YES]];
        request.predicate = predicate;
        
        NSError *error = nil;
        events = [self.managedObjectContext executeFetchRequest:request error:&error];
    }
    
    return events;
}

- (NSArray*)fetchTasksToDo{
    NSArray *events;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"repeat_attribute == nil"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:EVENT_START_TIME_KEY ascending:YES]];
    request.predicate = predicate;
    
    NSError *error = nil;
    events = [self.managedObjectContext executeFetchRequest:request error:&error];
    events;
    
    return events;
}



@end
