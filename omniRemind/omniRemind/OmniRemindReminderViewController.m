//
//  OmniRemindReminderViewController.m
//  omniRemind
//
//  Created by Mira Chen on 11/8/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "OmniRemindReminderViewController.h"
#import "OmniRemindDataManager.h"
#import "OmniRemindEventDetailViewController.h"
#import "Event.h"
@interface OmniRemindReminderViewController ()
@property (strong,nonatomic)NSMutableArray *events;
@property (strong,nonatomic)OmniRemindDataManager *manager;
@end

@implementation OmniRemindReminderViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Tasks";
//    self.events = self.manager
    
}

- (void)viewWillAppear:(BOOL)animated{
    NSArray *fetchedEvents =[self.manager fetchTasksToDo];
    self.events = [[NSMutableArray alloc]initWithArray:fetchedEvents];
    [self.tableView reloadData];
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
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"reminderCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Event *event = self.events[indexPath.row];
    cell.detailTextLabel.text = event.event_title;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    cell.textLabel.text = [dateFormat stringFromDate:event.event_date];
    
    return cell;
}


#pragma mark - Swipe to delete

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        Event *event = self.events[indexPath.row];
        [self.manager removeEvent:event.objectID];
        [self.events removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"seeEventDetail"]) {
        OmniRemindEventDetailViewController *destViewController = segue.destinationViewController;
        destViewController.title = @"Event Detail";
        NSIndexPath *indexPath;
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            indexPath = [self.tableView indexPathForCell:sender];
        }
        Event *event = self.events[indexPath.row];
        destViewController.eventTitle = event.event_title;
        destViewController.date = event.event_date;
        destViewController.startTime = event.start_time;
        destViewController.endTime = event.end_time;
        destViewController.location = event.event_location;
        destViewController.oid = [event objectID];
        if (event.cloud_event_id) {
            destViewController.cloudId = event.cloud_event_id;
            destViewController.myLocationKey = event.my_location_key;
            destViewController.otherLocationKey = event.other_location_key;
        }
    }
}



@end
