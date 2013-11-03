//
//  CalendarViewController.m
//  omniRemind
//
//  Created by WenXuan Cai on 11/1/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController ()

@property (weak, nonatomic) IBOutlet UIButton *lastMonth;
@property (weak, nonatomic) IBOutlet UIButton *nextMonth;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"today %i", [self getWeekday:[NSDate date]]);
    int monthNumber = 11;

    NSDate *date = [NSDate date];
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter monthSymbols]
}

- (void)getDate {
    
//NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];

    
    
//    
    int monthNumber = 11;   //November
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *monthName = [[df monthSymbols] objectAtIndex:(monthNumber-1)];
    

}

- (int)getWeekday:(NSDate *)date {
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    return [comp weekday]; // 1 = Sunday, 2 = Monday, etc.
}



@end
