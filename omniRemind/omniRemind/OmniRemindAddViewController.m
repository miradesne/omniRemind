//
//  OmniRemindAddViewController.m
//  omniRemind
//
//  Created by Mira Chen on 11/12/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "OmniRemindAddViewController.h"
#import "OmniRemindAddDetailViewController.h"
#import "CourseDataFetcher.h"
#import "OmniRemindCourse.h"
#import "OmniRemindDataManager.h"
#import "CloudEventSynchronizer.h"
#import "EventScheduler.h"
#import  "OmniRemindAddReminderViewController.h"

@interface OmniRemindAddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleInput;
@property (weak, nonatomic) IBOutlet UITextField *startTime;
@property (weak, nonatomic) IBOutlet UITextField *startDate;
@property (weak, nonatomic) IBOutlet UITextField *endTime;
@property (weak, nonatomic) IBOutlet UITextField *locationInput;
@property (weak, nonatomic) IBOutlet UISegmentedControl *addSegmentedControl;
@property (weak, nonatomic) IBOutlet UIView *addEventView;
@property (weak, nonatomic) IBOutlet UIView *addClassView;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (strong,nonatomic) OmniRemindDataManager *manager;
@property (strong,nonatomic) PFObject *fetchedCourse;
@property (weak, nonatomic) IBOutlet UISwitch *eventType;
@property (strong, nonatomic) NSString *cloudId;
@end


#define LOCATION_KEY1 @"location1"
#define LOCATION_KEY2 @"location2"
@implementation OmniRemindAddViewController

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
    self.manager = [[OmniRemindDataManager alloc]init];
	
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:animated];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



# pragma mark - init

- (UIDatePicker*) datePicker{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc]init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }
    return _datePicker;
}

- (UIDatePicker*) timePicker{
    if (!_timePicker) {
        _timePicker = [[UIDatePicker alloc]init];
        _timePicker.datePickerMode = UIDatePickerModeTime;
    }
    return _timePicker;
}

# pragma mark - toolBar

- (IBAction)cancelCreate:(id)sender {
    //self.tabBarController.selectedIndex = 0;
    [self dismissCurrentController];
}

# pragma mark - input
//- (void)dismissKeyboard{
//    [self.view endEditing:YES];
//    
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    
//    [textField resignFirstResponder];
//    return NO;
//}

- (void)done{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField.inputView isKindOfClass:[UIDatePicker class]]) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSString *theDate;
        if ([textField isEqual:self.startDate]) {
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            theDate = [dateFormat stringFromDate:self.datePicker.date];
            
        }
        else{
            [dateFormat setDateFormat:@"h:mm a"];
            theDate = [dateFormat stringFromDate:self.timePicker.date];
        }
        
        textField.text = [NSString stringWithFormat:@"%@",theDate];
        
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)extraSetup{

    [self addDatePicker:YES forInput:self.startDate];
    [self addDatePicker:NO forInput:self.startTime];
    [self addDatePicker:NO forInput:self.endTime];
    self.addClassView.hidden = YES;
}

- (void)addDatePicker:(Boolean)isDate forInput:(UITextField*)inputField{
    
    
    if (isDate) {
        inputField.inputView = self.datePicker;
    }
    else{
        inputField.inputView = self.timePicker;
    }
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:Nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    NSMutableArray *items = [[NSMutableArray alloc]init];
    [items addObject:space];
    [items addObject:done];
    pickerToolbar.items = items;
    
    inputField.inputAccessoryView = pickerToolbar;
    
}

# pragma mark - courseSearching

#define COURSE_INFO_HEIGHT 30
#define COURSE_LABEL_HEIGHT 30
#define COURSE_DESCRIPTION_HEIGHT 200
- (IBAction)changedSelection:(id)sender {
    int isCourse = self.addSegmentedControl.selectedSegmentIndex;
    if (isCourse) {
        self.addEventView.hidden = YES;
        self.addClassView.hidden = NO;
        [self showCourseSearchAlert];
    }
    else{
        self.addEventView.hidden = NO;
        self.addClassView.hidden = YES;
        [self clearCoursePage];
    }
    
}

- (void)clearCoursePage{
    
    NSMutableArray *subviewArray = [[NSMutableArray alloc]initWithArray:[self.addClassView subviews]];
    [subviewArray removeObject:self.searchButton];
    [subviewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)clearEventPage{
    self.titleInput.text = nil;
    self.locationInput.text = nil;
    self.startDate.text = nil;
    self.startTime.text = nil;
    self.endTime.text = nil;
    self.locationInput.text = nil;
    self.addSegmentedControl.selectedSegmentIndex = 0;
    self.addEventView.hidden = NO;
    self.addClassView.hidden = YES;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSString *searchTerm;
    if (alertView.tag == 1100) {
        if (buttonIndex == 1) {
            searchTerm = [alertView textFieldAtIndex:0].text;
            PFObject *courseObject = [CourseDataFetcher fetchCourse:searchTerm];
            NSLog(@"%@", courseObject);
            if (courseObject) {
                OmniRemindCourse *searchedCourse = [[OmniRemindCourse alloc] initWithFetchedCourse:courseObject];
                self.fetchedCourse = courseObject;
                //searchedCourse = nil;
                dispatch_async(dispatch_get_main_queue(),^{
                    if (searchedCourse) {
                        [self showSearchedCourse:searchedCourse];

                    }
                });
            } else {
                [self didNotFindCourse];
            }
        }
    } else if (alertView.tag == 1200) {
        if (buttonIndex == 1) {
            NSString *cloudEventId = [alertView textFieldAtIndex:0].text;
            PFObject *event = [CloudEventSynchronizer getEventFromId:cloudEventId];
            if (!event) {
                [self showCloudEventNotFoundAlertView];
            } else {
                [self addCloudEvent:event];
            }
        }
    } else if (alertView.tag == 1400) {
        if (buttonIndex == 0) {
            NSDate *remindTime;
            if (self.remindDict) {
                remindTime = [OmniRemindAddReminderViewController remindTimeStringToDate:[NSString stringWithFormat:@"%@ %@", self.startDate.text, self.startTime.text] remindDict:self.remindDict];
            }
            // Add a event.
            if (self.eventType.on) {
                // So this is a cloud event.
                NSString *lk1, *lk2;
                if (!self.cloudId) {
                    lk1 = LOCATION_KEY1;
                    lk2 = LOCATION_KEY2;
                } else {
                    lk1 = LOCATION_KEY2;
                    lk2 = LOCATION_KEY1;
                }
                [self.manager storeCloudEventWithTitle:self.titleInput.text date:self.startDate.text from:self.startTime.text to:self.endTime.text at:self.     locationInput.text myLocationKey:lk1 otherLocationKey:lk2
                                            withRepeat:self.repeatDict cloudId:self.cloudId withRemindDate:remindTime];
            } else {
                [self.manager storeEventWithTitle:self.titleInput.text date:self.startDate.text from:self.startTime.text to:self.endTime.text at:self.locationInput.text withRepeat:self.repeatDict withRemindDate:remindTime];
                if (self.remindDict) {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    dict[EVENT_DATE_KEY] = remindTime;
                    dict[EVENT_INFO_KEY] = self.titleInput.text;
                    dict[EVENT_REMIND_KEY] = self.remindDict;
                    if (self.repeatDict) {
                        dict[EVENT_REPEAT_KEY] = self.repeatDict;
                    }
                    [EventScheduler schduleEvent:dict];
                }
            }
            [self dismissCurrentController];
        }
    } else if (alertView.tag == 1500) {
        if (buttonIndex == 0) {
            [self.manager storeCourse:self.fetchedCourse];
            [self dismissCurrentController];
        }
    }
    
}

- (void)showCourseSearchAlert{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Class Search"
                                                          message:@""
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Search", nil];
    myAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    myAlertView.tag = 1100;
    [myAlertView show];
}

- (void)didNotFindCourse{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Course not found!"
                                                          message:@""
                                                         delegate:self
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles:nil];
    myAlertView.tag = 1600;
    [myAlertView show];
//    [self addSearchButton];
}

- (void)showSearchedCourse: (OmniRemindCourse*)searchedCourse{
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray = class_copyPropertyList([OmniRemindCourse class], &numberOfProperties);
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 280, COURSE_INFO_HEIGHT)];
    infoLabel.text = @"Course Information" ;
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.font = [UIFont systemFontOfSize:18];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    //[courseInfoLabel sizeToFit];
    [self.addClassView addSubview:infoLabel];
    
    int previousHeight = 40;
    for (int i = 0; i < numberOfProperties; i++) {
        objc_property_t property = propertyArray[i];
        NSString *propertyName = [[NSString alloc] initWithUTF8String:property_getName(property)];
        id propertyValue = [searchedCourse valueForKey:propertyName];
        NSString *courseInfo = [NSString stringWithFormat:@"%@ : %@",propertyName,propertyValue];
        
        if ([propertyName isEqualToString:@"courseDescription"]) {
            UITextView *courseDescriptionLabel = [[UITextView alloc] initWithFrame:CGRectMake(20, previousHeight, 280, COURSE_DESCRIPTION_HEIGHT)];
            courseDescriptionLabel.text = courseInfo;
            courseDescriptionLabel.editable = NO;
            courseDescriptionLabel.textContainer.lineFragmentPadding = 0;
            [self.addClassView addSubview:courseDescriptionLabel];
            previousHeight += COURSE_DESCRIPTION_HEIGHT;
        } else{
            UILabel *courseInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, previousHeight, 280, COURSE_LABEL_HEIGHT)];
            courseInfoLabel.text = courseInfo ;
            courseInfoLabel.backgroundColor = [UIColor clearColor];
            courseInfoLabel.font = [UIFont systemFontOfSize:12];
            courseInfoLabel.lineBreakMode = NSLineBreakByWordWrapping;
            courseInfoLabel.numberOfLines = 0;
            //[courseInfoLabel sizeToFit];
            [self.addClassView addSubview:courseInfoLabel];
            previousHeight += COURSE_LABEL_HEIGHT;
            
        }
    }
}

- (IBAction)searchCourse:(id)sender {
    [self showCourseSearchAlert];
}

#pragma mark - DataBase

- (IBAction)addEvent:(id)sender {
    int isCourse = self.addSegmentedControl.selectedSegmentIndex;
    if (isCourse) {
        if (self.fetchedCourse) {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Add Course"
                                                                  message:@"Do you want to add all course info?"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                        otherButtonTitles:@"YES", @"NO", nil];
            myAlertView.tag = 1500;
            [myAlertView show];
        } else {
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Couse Error"
                                                                  message:@"Please search for a valid course before adding"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                        otherButtonTitles:nil, nil];
            myAlertView.tag = 1600;
            [myAlertView show];
        }
    } else {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Add Event"
                                                              message:@"Do you want to add this event?"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                                    otherButtonTitles:@"YES", @"NO", nil];
        myAlertView.tag = 1400;
        [myAlertView show];
    }
}


#pragma mark - Segue and other transitions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
}

- (void)dismissCurrentController{
    // Get views. controllerIndex is passed in as the controller we want to go to.
    int controllerIndex = 0;
    UIView * fromView = self.tabBarController.selectedViewController.view;
    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:controllerIndex] view];
    self.tabBarController.tabBar.hidden = NO;
    [self clearCoursePage];
    [self clearEventPage];
    // Transition using a page curl.
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:(controllerIndex > self.tabBarController.selectedIndex ? UIViewAnimationOptionTransitionCurlUp : UIViewAnimationOptionTransitionCurlDown)
                    completion:^(BOOL finished) {
                        if (finished) {
                            self.tabBarController.selectedIndex = controllerIndex;
                        }
                    }];
}

- (IBAction)searchCloudEvent:(id)sender {
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Cloud Event Search"
                                                          message:@"Please type the cloud event id here"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Search", nil];
    
    myAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    myAlertView.tag = 1200;
    [myAlertView show];
}

- (void)showCloudEventNotFoundAlertView {
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Cloud Event Not Found"
                                                          message:@"The event id does not exist"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:nil];
    myAlertView.tag = 1300;
    [myAlertView show];
}

- (void)addCloudEvent:(PFObject *)event {
    self.titleInput.text = event[EVENT_TITLE_KEY];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    self.startDate.text = [dateFormat stringFromDate:event[EVENT_DATE_KEY]];
    [dateFormat setDateFormat:@"h:mm a"];
    self.startTime.text = [dateFormat stringFromDate:event[EVENT_FROM_KEY]];
    self.endTime.text = [dateFormat stringFromDate:event[EVENT_TO_KEY]];
    self.eventType.on = YES;
    self.cloudId = [event objectId];
}

@end
