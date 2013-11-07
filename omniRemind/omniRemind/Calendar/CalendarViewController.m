//
//  CalendarViewController.m
//  omniRemind
//
//  Created by WenXuan Cai on 11/1/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "CalendarViewController.h"
#import "OmniRemindDayViewController.h"
#import "OmniRemindCalendarCollectionViewCell.h"
@interface CalendarViewController ()

@property (weak, nonatomic) IBOutlet UIButton *lastMonth;
@property (weak, nonatomic) IBOutlet UIButton *nextMonth;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) NSString *dayViewName;
@property (strong, nonatomic) NSArray *dates;
@property (strong, nonatomic) NSArray *dateComponents;

@end

#define MONTH_NAME_LENGTH 3
#define NUMBER_MONTHS_PER_YEAR 12
#define NUMBER_DATES_DISPLAY 42
#define DATE_COMPONENT_YEAR  @"component_year"
#define DATE_COMPONENT_MONTH  @"component_month"
#define DATE_COMPONENT_DAY  @"component_day"
@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCalendar];
    [self setUpCollectionView];
}

#pragma mark - calendarInit

- (void)initCalendar {
    NSDate *today = [NSDate date];

    int currentMonth = [self getDateComponent:today componentName:DATE_COMPONENT_MONTH];
    int nextMonth = ([self getDateComponent:today componentName:DATE_COMPONENT_MONTH] + 1) % (NUMBER_MONTHS_PER_YEAR + 1);
    int lastMonth = ([self getDateComponent:today componentName:DATE_COMPONENT_MONTH] - 1) % (NUMBER_MONTHS_PER_YEAR + 1);
    NSString *currentMonthName = [self getMonthName:currentMonth];
    NSString *nextMonthName = [[self getMonthName:nextMonth] substringToIndex:MONTH_NAME_LENGTH];
    NSString *lastMonthName = [[self getMonthName:lastMonth] substringToIndex:MONTH_NAME_LENGTH];
    [self setCalendarTitle:currentMonthName];
    [self.nextMonth setTitle:nextMonthName forState:UIControlStateNormal];
    [self.lastMonth setTitle:lastMonthName forState:UIControlStateNormal];
    [self initDates];
}

- (void)initDates {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *today = [NSDate date];
    NSRange range = [self getDatesInTheMonth:today];
    NSDateComponents *comp = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:today];
    [comp setDay:1];
    int weekdayOfCurrentMonthFirstDay = [self getWeekday:[calendar dateFromComponents:comp]];
    NSLog(@"%@ %i", [calendar dateFromComponents:comp], weekdayOfCurrentMonthFirstDay);
    
    
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    NSMutableArray *dateComponents = [[NSMutableArray alloc] init];
    [comp setMonth:[comp month] - 1];
    NSRange lastMonthRange = [self getDatesInTheMonth: [calendar dateFromComponents:comp]];
    NSLog(@"%i %i", [self getWeekday:today], lastMonthRange.length);
    
    for (int t = lastMonthRange.length - weekdayOfCurrentMonthFirstDay + 2; t <= lastMonthRange.length; t++) {
        [dates addObject:[NSString stringWithFormat:@"%i", t]];
    }
    for (int t = range.location; t <= range.length; t++) {
        [dates addObject:[NSString stringWithFormat:@"%i", t]];
    }
    int t = 1;
    while ([dates count] < NUMBER_DATES_DISPLAY) {
        [dates addObject:[NSString stringWithFormat:@"%i", t++]];
    }
    NSLog(@"%@", dates);
    self.dates = dates;
}

// Costemize title here.
- (void)setCalendarTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"GoodMobiPro-CondBold" size:24];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textColor = [UIColor blackColor];
    self.navigationItem.titleView = label;
    label.text = title;
    [label sizeToFit];
}

// Get the dates range for the month of the day passed in.
- (NSRange)getDatesInTheMonth:(NSDate *)monthOfThisDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar rangeOfUnit:NSDayCalendarUnit
                          inUnit:NSMonthCalendarUnit
                         forDate:monthOfThisDate];
}

- (NSDate *)getMonth:(NSDate *)fromNow forMonths:(int)forMonths {
    NSDateComponents *oneMonth = [[NSDateComponents alloc] init];
    oneMonth.month = forMonths;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingComponents:oneMonth toDate:fromNow options:0];
}

- (NSString *)getMonthName:(int)monthNumber {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    return [[df monthSymbols] objectAtIndex:(monthNumber - 1)];
}

// Get the weekday of a date, exp: Mon, Tue...
- (int)getWeekday:(NSDate *)date {
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSWeekdayCalendarUnit fromDate:date];
    return [comp weekday]; // 1 = Sunday, 2 = Monday, etc.
}

// Get a component as int from a NSDate.
- (int)getDateComponent:(NSDate *)date componentName:(NSString *)componentName {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    int component = 0;
    if ([componentName isEqualToString:DATE_COMPONENT_YEAR]) {
        component = [components year];
    } else if ([componentName isEqualToString:DATE_COMPONENT_MONTH]) {
        component = [components month];
    } else if ([componentName isEqualToString:DATE_COMPONENT_DAY]) {
        component = [components day];
    }
    return component;
}


#pragma mark - collectionViewInit

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return NUMBER_DATES_DISPLAY;
}


- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:self.dayViewName  forIndexPath:indexPath];
    cell.contentView.layer.borderColor = [[UIColor blackColor] CGColor];
    cell.contentView.layer.borderWidth = 0.5;
    OmniRemindCalendarCollectionViewCell *calendarCell = (OmniRemindCalendarCollectionViewCell *)cell;
    calendarCell.dateLabel.text = self.dates[indexPath.row];
    // Last month's dates are fill out.
    int indexFirstDay = [self.dates indexOfObject:@"1"];
    NSRange range = NSMakeRange(indexFirstDay, [self.dates count] - indexFirstDay);
//    NSLog(@"%@", range);
//    NSLog(@"%i", [self.dates indexOfObject:@"1" inRange:range]);
    if (indexPath.row < indexFirstDay) {
        calendarCell.dateLabel.textColor = [UIColor grayColor];
        calendarCell.dateLabel.alpha = 0.5;
    }
    return cell;
    
}

- (void)setUpCollectionView {
    self.dayViewName = @"eventView";
    
}
- (IBAction)viewEventDetail:(UITapGestureRecognizer *)sender {
    
}

#pragma mark - Segue
//transfer the Image to the next view
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self performSegueWithIdentifier:@"seeDayView" sender:collectionView];
//}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"seeDayView"]) {
        OmniRemindDayViewController *destViewController = segue.destinationViewController;
        NSIndexPath *indexPath ;
        if ([sender isKindOfClass:[UICollectionViewCell class]]) {
            indexPath = [self.collectionView indexPathForCell:sender];
        }
        //OmniRemindCalendarCollectionViewCell *cell = (OmniRemindCalendarCollectionViewCell*)[self.collectionView dequeueReusableCellWithReuseIdentifier:self.dayViewName  forIndexPath:indexPath];
        
        UILabel *titleView = (UILabel*)self.navigationItem.titleView;
        destViewController.title = [NSString stringWithFormat:@"%@ %@",titleView.text,self.dates[indexPath.row]];
        destViewController.indexPath = indexPath;
        
    }
}

- (void)segueSetup:(UIStoryboardSegue*)segue withIndexPath:(NSIndexPath*)index {
    
}


@end
