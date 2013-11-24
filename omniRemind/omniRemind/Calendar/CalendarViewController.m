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
#import <Parse/Parse.h>
#import "CourseDataFetcher.h"
@interface CalendarViewController ()

@property (weak, nonatomic) IBOutlet UIButton *lastMonth;
@property (weak, nonatomic) IBOutlet UIButton *nextMonth;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) NSString *dayViewName;
@property (strong, nonatomic) NSArray *dates;
@property (strong, nonatomic) NSArray *dateComponents;

// This date is going to determine the month that we are looking at.
// Would init to the current date at the beginning.
@property (strong, nonatomic) NSDate *referenceDate;

@end

#define MONTH_NAME_LENGTH 3
#define NUMBER_MONTHS_PER_YEAR 12
#define NUMBER_DATES_DISPLAY 42
#define DATE_COMPONENT_YEAR  @"component_year"
#define DATE_COMPONENT_MONTH  @"component_month"
#define DATE_COMPONENT_DAY  @"component_day"
#define TITLE_FONT_SIZE 18
@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCalendar];
    [self setUpCollectionView];
}

- (void)registerChannel:(NSString *)channelName {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject:channelName forKey:@"channels"];
    [currentInstallation saveInBackground];
    NSLog(@"reg");
}


- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [super viewWillAppear:animated];
    
}

- (NSDate *)referenceDate {
    if (!_referenceDate) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
        [comp setDay: 1];
        _referenceDate = [calendar dateFromComponents:comp];
    }
    return _referenceDate;
}

#pragma mark - calendarInit

- (void)initCalendar {
    // Swith back and forth to get the day range of next / last month.
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.referenceDate];
    int currentMonth = [self getDateComponent:self.referenceDate componentName:DATE_COMPONENT_MONTH];
    [comp setMonth:[comp month] + 1];
    int nextMonth = [self getDateComponent:[calendar dateFromComponents:comp] componentName:DATE_COMPONENT_MONTH];
    [comp setMonth:[comp month] - 2];
    int lastMonth = [self getDateComponent:[calendar dateFromComponents:comp] componentName:DATE_COMPONENT_MONTH];
    
    NSString *currentMonthName = [self getMonthName:currentMonth];
    NSString *nextMonthName = [[self getMonthName:nextMonth] substringToIndex:MONTH_NAME_LENGTH];
    NSString *lastMonthName = [[self getMonthName:lastMonth] substringToIndex:MONTH_NAME_LENGTH];
    [self setCalendarTitle:currentMonthName year:[NSString stringWithFormat:@"%i", [self getDateComponent:self.referenceDate componentName:DATE_COMPONENT_YEAR]]];
    [self.nextMonth setTitle:nextMonthName forState:UIControlStateNormal];
    [self.lastMonth setTitle:lastMonthName forState:UIControlStateNormal];
    [self initDates];
}

- (void)initDates {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.referenceDate];
    [comp setDay:1];
    int weekdayOfCurrentMonthFirstDay = [self getWeekday:[calendar dateFromComponents:comp]];
    NSRange range = [self getDatesInTheMonth:self.referenceDate];
    
    NSMutableArray *dates = [[NSMutableArray alloc] init];
   // NSMutableArray *dateComponents = [[NSMutableArray alloc] init];//maybe?
    [comp setMonth:[comp month] - 1];
    NSRange lastMonthRange = [self getDatesInTheMonth: [calendar dateFromComponents:comp]];
    
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
    self.dates = dates;
}

// Costemize title here.
- (void)setCalendarTitle:(NSString *)month year:(NSString *)year {
    // Hard code those values.... they are from experiments... I hate UI!!!!!!!!!
    CGRect headerTitleSubtitleFrame = CGRectMake(0, 0, 200, 44);
    UIView* _headerTitleSubtitleView = [[UILabel alloc] initWithFrame:headerTitleSubtitleFrame];
    _headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
    _headerTitleSubtitleView.autoresizesSubviews = YES;
    
    CGSize size = [month sizeWithFont:[UIFont boldSystemFontOfSize:TITLE_FONT_SIZE]];
    CGRect titleFrame = CGRectMake(105 - 10 - size.width, 10, 200, 24);
    UILabel *titleView = [[UILabel alloc] initWithFrame:titleFrame];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont boldSystemFontOfSize:TITLE_FONT_SIZE];
    titleView.textColor = [UIColor blackColor];
    titleView.shadowColor = [UIColor darkGrayColor];
    titleView.shadowOffset = CGSizeMake(0, -1);
    titleView.text = month;
    titleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:titleView];
    
    CGRect subtitleFrame = CGRectMake(105, 10, 200, 24);
    UILabel *subtitleView = [[UILabel alloc] initWithFrame:subtitleFrame];
    subtitleView.backgroundColor = [UIColor clearColor];
    subtitleView.font = [UIFont boldSystemFontOfSize:TITLE_FONT_SIZE];
    subtitleView.textColor = [UIColor whiteColor];
    subtitleView.shadowColor = [UIColor darkGrayColor];
    subtitleView.shadowOffset = CGSizeMake(0, -1);
    subtitleView.text = year;
    subtitleView.adjustsFontSizeToFitWidth = YES;
    [_headerTitleSubtitleView addSubview:subtitleView];
    
    _headerTitleSubtitleView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                                 UIViewAutoresizingFlexibleRightMargin |
                                                 UIViewAutoresizingFlexibleTopMargin |
                                                 UIViewAutoresizingFlexibleBottomMargin);
    
    self.navigationItem.titleView = _headerTitleSubtitleView;
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
    // Last / next month's dates are gray out.
    int indexFirstDay = [self.dates indexOfObject:@"1"];
    // Here first set the cell to default.
    calendarCell.dateLabel.textColor = [UIColor blackColor];
    calendarCell.dateLabel.alpha = 1;
    NSRange range = NSMakeRange(indexFirstDay + 1, [self.dates count] - indexFirstDay - 1);
    int deltaMonth = 0;
    // If it's last month.
    if (indexPath.row < indexFirstDay) {
        deltaMonth = -1;
    } else if (indexPath.row >= [self.dates indexOfObject:@"1" inRange:range]) {
        deltaMonth = 1;
    }
    if (deltaMonth != 0) {
        calendarCell.dateLabel.textColor = [UIColor grayColor];
        calendarCell.dateLabel.alpha = 0.5;
    }
    int day = [((NSString *)self.dates[indexPath.row]) intValue];
    calendarCell.date = [self createDateFromReferenceDate:day deltaMonth:deltaMonth];
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
        
        UILabel *titleView = (UILabel*)[self.navigationItem.titleView subviews][0];
        destViewController.title = [NSString stringWithFormat:@"%@ %@",titleView.text,self.dates[indexPath.row]];
        destViewController.indexPath = indexPath;
        
    }
}

- (void)segueSetup:(UIStoryboardSegue*)segue withIndexPath:(NSIndexPath*)index {
    
}

- (IBAction)goToLastMonth:(id)sender {
    [self adjustReferenceDate:-1];
}

- (IBAction)goToNextMonth:(id)sender {
    [self adjustReferenceDate:1];
}

// Based on the reference date, change the reference month by delta amount, and reset the UI.
- (void)adjustReferenceDate:(int)deltaMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.referenceDate];
    [comp setMonth:[comp month] + deltaMonth];
    [comp setDay: 1];
    self.referenceDate = [calendar dateFromComponents:comp];
    [self initCalendar];
    [self setUpCollectionView];
    [self.collectionView reloadData];
}

// create Date:  year | referenceDate.month + deltaMonth | day
- (NSDateComponents *)createDateFromReferenceDate:(int)day deltaMonth:(int)deltaMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self.referenceDate];
    [comp setMonth:[comp month] + deltaMonth];
    [comp setDay: day];
    return comp;
}

@end
