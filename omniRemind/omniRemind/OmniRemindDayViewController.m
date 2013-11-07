//
//  OmniRemindDayViewController.m
//  omniRemind
//
//  Created by Mira Chen on 11/5/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "OmniRemindDayViewController.h"

@interface OmniRemindDayViewController ()
@property (nonatomic,strong) NSMutableArray* events;
@end

@implementation OmniRemindDayViewController



#pragma mark - initialization

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self initializeSampleData];
    }
    return self;
}

- (void)initializeSampleData{
    NSDateComponents *startTime = [[NSDateComponents alloc] init];
    [startTime setHour:6];
    [startTime setMinute:30];
    NSDateComponents *endTime = [[NSDateComponents alloc]init];
    [endTime setHour:8];
    [endTime setMinute:0];
    NSMutableDictionary *event = [[NSMutableDictionary alloc]initWithDictionary:@{@"startTime":startTime,@"endTime":endTime}];
    
    [self.events addObject:event];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];

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

#define CELL_HEIGHT 44

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}


#define TIME_LABEL_HEIGHT 40

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

- (void)updateCalendarUI{
    
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
