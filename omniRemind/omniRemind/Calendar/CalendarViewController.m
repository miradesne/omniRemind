//
//  CalendarViewController.m
//  omniRemind
//
//  Created by WenXuan Cai on 11/1/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "CalendarViewController.h"
#import "OmniRemindDayViewController.h"
@interface CalendarViewController ()

@property (weak, nonatomic) IBOutlet UIButton *lastMonth;
@property (weak, nonatomic) IBOutlet UIButton *nextMonth;
@property (weak, nonatomic) IBOutlet UILabel *currentMonth;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) NSString *cardViewName;
@end

#define MONTH_NAME_LENGTH 3
#define NUMBER_MONTHS_PER_YEAR 12
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
    [self.currentMonth setText:currentMonthName];
    [self.nextMonth setTitle:nextMonthName forState:UIControlStateNormal];
    [self.lastMonth setTitle:lastMonthName forState:UIControlStateNormal];
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
    NSDateComponents* comp = [cal components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
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

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 35;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:self.cardViewName  forIndexPath:indexPath];
    
    
    return cell;
    
}

-(void)setUpCollectionView{
    self.cardViewName = @"eventView";
    
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
        NSLog([NSString stringWithFormat:@"%@",indexPath]);
       destViewController.title=[NSString stringWithFormat:@"Cell: %@",indexPath];
    }
}

-(void)segueSetup:(UIStoryboardSegue*)segue withIndexPath:(NSIndexPath*)index{
    
}


@end
