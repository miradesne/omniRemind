//
//  OmniRemindAddReminderViewController.m
//  omniRemind
//
//  Created by Mira Chen on 11/30/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "OmniRemindAddReminderViewController.h"
#import "OmniRemindAddViewController.h"
@interface OmniRemindAddReminderViewController ()
@property (weak, nonatomic) IBOutlet UIButton *remindTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *remindTimeButton;
@property (strong, nonatomic) NSMutableDictionary *remindDict;

@end

@implementation OmniRemindAddReminderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (NSMutableDictionary*)remindDict{
    if (!_remindDict) {
        _remindDict = [[NSMutableDictionary alloc] initWithDictionary:@{REMIND_TYPE_KEY:@(NO_REMINDER),REMIND_TIME_KEY:@(MINUTES_15)}];
        
    }
    return _remindDict;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changeRemindType:(id)sender {
    UIActionSheet *selectTypeActionSheet = [[UIActionSheet alloc]initWithTitle:@"Remind Type:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"No Reminder",@"Push Notification",@"SMS(not in beta version)",nil];
    selectTypeActionSheet.tag = 100;
    [selectTypeActionSheet showInView:self.view];
}

- (IBAction)changeRemindTime:(id)sender {
    UIActionSheet *selectTypeActionSheet = [[UIActionSheet alloc]initWithTitle:@"Remind:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"15 mins before",@"30 mins before",@"1 hour before",@"1 day before", @"1 week before",nil];
    selectTypeActionSheet.tag = 101;
    [selectTypeActionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        switch (buttonIndex) {
            case 0:
                [self.remindDict setValue:@(NO_REMINDER) forKey:REMIND_TYPE_KEY];
                [self.remindTypeButton setTitle:@"No Reminder" forState:UIControlStateNormal];
                break;
                
            case 1:
                [self.remindDict setValue:@(PUSH_NOTIFICATION) forKey:REMIND_TYPE_KEY];
                [self.remindTypeButton setTitle:@"Push" forState:UIControlStateNormal];
                break;
                
            case 2:
                [self.remindDict setValue:@(SMS_NOTIFICATION) forKey:REMIND_TYPE_KEY];
                [self.remindTypeButton setTitle:@"SMS" forState:UIControlStateNormal];
                break;            default:
                NSLog(@"default");
                break;
        }
    }
    else{
        switch (buttonIndex) {
            case 0:
                [self.remindDict setValue:@(MINUTES_15) forKey:REMIND_TIME_KEY];
                [self.remindTimeButton setTitle:@"15 mins before" forState:UIControlStateNormal];
                break;
                
            case 1:
                [self.remindDict setValue:@(MINUTES_30) forKey:REMIND_TIME_KEY];
                [self.remindTimeButton setTitle:@"30 mins before" forState:UIControlStateNormal];
                break;
                
            case 2:
                [self.remindDict setValue:@(HOUR_BEFORE) forKey:REMIND_TIME_KEY];
                [self.remindTimeButton setTitle:@"1 hour before" forState:UIControlStateNormal];
                break;
            
            case 3:
                [self.remindDict setValue:@(DAY_BEFORE) forKey:REMIND_TIME_KEY];
                [self.remindTimeButton setTitle:@"1 day before" forState:UIControlStateNormal];
                break;
                
            case 4:
                [self.remindDict setValue:@(HOUR_BEFORE) forKey:REMIND_TIME_KEY];
                [self.remindTimeButton setTitle:@"1 week before" forState:UIControlStateNormal];
                break;
            
            default:
                NSLog(@"default");
                break;
        }
 
    }
}
- (IBAction)finishReminderSetting:(id)sender {
    OmniRemindAddViewController *addController = (OmniRemindAddViewController*)[self backViewController];
    addController.remindDict = self.remindDict;
    NSLog(@"%@",self.remindDict);
    NSValue *v = self.remindDict[REMIND_TIME_KEY];
    NSLog(@"%i", [v isEqualToValue:@(NO_REMINDER)]);
    [self.navigationController popViewControllerAnimated:YES];

}

+ (NSDate *)remindTimeStringToDate:(NSString *)rtime remindDict:(NSDictionary *)remindDict {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd h:mm a"];
    NSDate *date = [df dateFromString:rtime];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    NSValue *timeValue = remindDict[REMIND_TIME_KEY];
    int time;
    [timeValue getValue:&time];
    switch (time) {
        case MINUTES_15:
            [comp setMinute:[comp minute] - 15];
            break;
        case MINUTES_30:
            [comp setMinute:[comp minute] - 30];
            break;
        case HOUR_BEFORE:
            [comp setHour:[comp hour] - 1];
            break;
        case DAY_BEFORE:
            [comp setDay:[comp day] - 1];
            break;
        case WEEK_BEFORE:
            [comp setDay:[comp day] - 7];
            break;
    }
    return [calendar dateFromComponents:comp];
}

@end
