//
//  OmniRemindDayViewController.m
//  omniRemind
//
//  Created by Mira Chen on 11/5/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "OmniRemindDayViewController.h"
#import "OmniRemindEventDetailViewController.h"
#import "OmniRemindDataManager.h"
#import "Event+Create.h"
@interface OmniRemindDayViewController ()
@property (nonatomic,strong) NSMutableArray* events;
@property (nonatomic,strong) NSMutableArray* occupied;
@property (nonatomic,strong) OmniRemindDataManager *manager;
@property (nonatomic, strong) NSMutableArray *rects;
// Events map by the rects.
@property (nonatomic,strong) NSMutableArray* eventsInOrder;

@end

@implementation OmniRemindDayViewController


#define CELL_HEIGHT 44
#define TIME_LABEL_HEIGHT 40
#define CONTENT_WIDTH 230
#define LEFT_MARGIN 60

#pragma mark - initialization



- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
       // self.events = nil;
        if (!self.manager) {
            self.manager = [[OmniRemindDataManager alloc]init];
        }
//        [self initializeSampleData];
    }
    return self;
}

- (NSMutableArray *)rects {
    if (!_rects) {
        _rects = [[NSMutableArray alloc] init];
    }
    return _rects;
}

- (NSMutableArray*)events{
    if (!_events) {
        _events = [[NSMutableArray alloc]init];
    }
    return _events;
}

- (NSMutableArray*)occupied{
    if (!_occupied){
        _occupied = [[NSMutableArray alloc]init];
    }
    return _occupied;
}

- (NSMutableArray *)eventsInOrder {
    if (!_eventsInOrder) {
        _eventsInOrder = [[NSMutableArray alloc] init];
    }
    return _eventsInOrder;
}

- (void)initializeSampleData{
    int startHours[] = {6,9,10,14,20};
    int endHours[] = {8,10,12,17,22};
    int startMinutes[] = {30,15,0,0,45};
    int endMinutes[] = {0,30,15,0,15};
    NSArray *eventTitles = @[@"Senior Design",@"Elec 446",@"hang out with Wendy",@"Singing practice",@"Soccer"];
    for (int i = 0; i<5; i++) {
        NSDateComponents *startTime = [[NSDateComponents alloc] init];
        [startTime setHour:startHours[i]];
        [startTime setMinute:startMinutes[i]];
        NSDateComponents *endTime = [[NSDateComponents alloc]init];
        [endTime setHour:endHours[i]];
        [endTime setMinute:endMinutes[i]];
        NSMutableDictionary *event = [[NSMutableDictionary alloc]initWithDictionary:@{@"startTime":startTime,@"endTime":endTime,@"eventTitle":eventTitles[i],@"eventLocation":@"location"}];
        
        [self.events addObject:event];

    }
    
    for (int i = 0 ; i < 24 ; i++){
        [self.occupied addObject:[NSNumber numberWithInt:0]];
    }
    [self calculateOccupied];
    
    
}

- (void)loadActuallData{
    NSArray *fetchedEvents = [self.manager fetchEventsWithDate:self.dateComp];
    
    
    
    
    NSLog(@"%@",fetchedEvents);
    self.events = [[NSMutableArray alloc]initWithArray:fetchedEvents];
    for (int i = 0 ; i < 24 ; i++){
        [self.occupied addObject:[NSNumber numberWithInt:0]];
    }
    
    
    [self calculateOccupied];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated{
    [self loadActuallData];
    [self updateCalendarUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 24;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"timeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, -6+indexPath.row*CELL_HEIGHT, 20, TIME_LABEL_HEIGHT)];
    if (indexPath.row == 0){
        timeLabel.text = [NSString stringWithFormat:@"12 AM"];
    }
    else if (indexPath.row < 12) {
        timeLabel.text = [NSString stringWithFormat:@"%d AM",indexPath.row];
    }
    else if (indexPath.row == 12){
        timeLabel.text = [NSString stringWithFormat:@"12 PM"];
    }
    else{
        timeLabel.text = [NSString stringWithFormat:@"%d PM",indexPath.row-12];
    }
    
    timeLabel.backgroundColor = [UIColor whiteColor];
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.font = [UIFont systemFontOfSize:10];
    [timeLabel sizeToFit];
    [self.tableView addSubview:timeLabel];
    
    
    return cell;
}


#pragma mark -drawUI


- (void)calculateOccupied{
    for (Event *event in self.events){
        
        NSDateComponents *startTime = [self getDatecomponentFromNSDate:event.start_time];
        NSDateComponents *endTime = [self getDatecomponentFromNSDate:event.end_time];
        int startHour = startTime.hour;
        int endHour = endTime.hour;
        if (endTime.minute > 0) {
            endHour += 1 ;
        }
        for (int i = startHour ; i < endHour; i++){
            NSNumber *numberOfCurrent = self.occupied[i];
            self.occupied[i] =  @(numberOfCurrent.integerValue+1);
        }
        
    }
    
}
- (void)updateCalendarUI{
    int indent = 0;
    for (Event *event in self.events){
       indent = [self drawEvent:event withIndent:indent];
        
    }
}

#define EVENT_LABEL_HEIGHT 20
- (int)drawEvent:(Event*)event withIndent:(int)indentation{
    NSDateComponents *startTime = [self getDatecomponentFromNSDate:event.start_time];
    NSDateComponents *endTime = [self getDatecomponentFromNSDate:event.end_time];
    int startHour = startTime.hour;
    int endHour = endTime.hour;
    int numberOfEvent = [self getEventNumber:startHour withEndTime:endHour+1];
    int eventWidth = floor(CONTENT_WIDTH/(float)numberOfEvent);
    float topMargin = startHour * CELL_HEIGHT+startTime.minute/60.0 * CELL_HEIGHT ;
    float bottom = endTime.hour * CELL_HEIGHT + endTime.minute/60.0 * CELL_HEIGHT;
    CGRect rect = CGRectMake(LEFT_MARGIN+indentation*eventWidth,topMargin , eventWidth, bottom - topMargin);
    UIView *eventView = [[UIView alloc] initWithFrame:rect];
    // Add the rect.
    [self.rects addObject:[NSValue valueWithCGRect:rect]];
    [self.eventsInOrder addObject:event];
    eventView.backgroundColor = [UIColor colorWithRed:181/255.0 green:214/255.0 blue:236/255.0 alpha:0.8];
    eventView.layer.cornerRadius = 5 ;
    eventView.layer.masksToBounds = YES;
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 50, EVENT_LABEL_HEIGHT)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 15, eventWidth - 20, EVENT_LABEL_HEIGHT)];
    UILabel *locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 35, 50, EVENT_LABEL_HEIGHT)];
    if (startHour > 12) {
        startHour -= 12;
    }
    if (endHour > 12){
        endHour -= 12;
    }
    timeLabel.text = [NSString stringWithFormat:@"%d - %d",startHour,endHour];
    titleLabel.text = event.event_title;
    locationLabel.text = event.event_location;
    timeLabel.font = [UIFont systemFontOfSize:10];
    titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:12];
    titleLabel.numberOfLines = 0 ;
    locationLabel.font = [UIFont systemFontOfSize:10];
    [timeLabel sizeToFit];
    [locationLabel sizeToFit];
    [eventView addSubview:timeLabel];
    [eventView addSubview:titleLabel];
    [eventView addSubview:locationLabel];
    [self.tableView addSubview:eventView];
    
    NSLog(@"%i %f %i %f", LEFT_MARGIN+indentation*eventWidth,topMargin , eventWidth, bottom - topMargin);
    if (indentation < numberOfEvent-1){
        indentation +=1;
    }
    else{
        indentation = 0;
    }
    return indentation;
}

- (int)getEventNumber:(int)startHour withEndTime:(int)endHour{
    NSArray *period = [self.occupied subarrayWithRange:NSMakeRange(startHour, endHour-startHour)];
    return [[period valueForKeyPath:@"@max.intValue"] integerValue];

}


- (NSDateComponents*)getDatecomponentFromNSDate:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit) fromDate:date];
    return comp;
}

#pragma mark - transitionToDetailView
- (IBAction)tapEventHandler:(UITapGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.view];
    for (int t = 0; t < [self.rects count]; t++) {
        NSValue *value = self.rects[t];
        CGRect rect = value.CGRectValue;
        if (location.x > rect.origin.x && location.y > rect.origin.y) {
            if (location.x < rect.origin.x + rect.size.width && location.y < rect.origin.y + rect.size.height) {
                // Find an event on the point...
                NSLog(@"%@", self.eventsInOrder[t]);
                [self performSegueWithIdentifier:@"seeEventDetail" sender:self.eventsInOrder[t]];
                break;
            }
        }
    }
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"seeEventDetail"]) {
        OmniRemindEventDetailViewController *destViewController = segue.destinationViewController;
        destViewController.title = @"Event Detail";
        [destViewController call];
        Event *event = (Event *)sender;
        destViewController.title = event.event_title;
        NSLog(@"dest title %@", destViewController.title);
        destViewController.startTime = event.start_time;
        destViewController.endTime = event.end_time;
        destViewController.location = event.event_location;
        if (event.cloud_event_id) {
            destViewController.cloudId = event.cloud_event_id;
        }
    }
}


@end
