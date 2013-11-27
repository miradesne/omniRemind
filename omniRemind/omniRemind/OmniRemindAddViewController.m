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
@end

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
	
    [self setUpInput];
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
    self.tabBarController.selectedIndex = 0;
    
}

# pragma mark - input
- (void)dismissKeyboard{
    [self.view endEditing:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return NO;
}

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

- (void)setUpInput{
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    UIView *targetView = [self.view viewWithTag:109];
    [targetView addGestureRecognizer:tap];
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
- (IBAction)changedSelection:(id)sender {
    int isCourse = self.addSegmentedControl.selectedSegmentIndex;
    if (isCourse) {
        self.addEventView.hidden = YES;
        self.addClassView.hidden = NO;
        self.searchButton.hidden = YES;
        [self showCourseSearchAlert];
    }
    else{
        self.addEventView.hidden = NO;
        self.addClassView.hidden = YES;
        [[self.addClassView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSString *searchTerm;
    if (alertView.tag == 1100) {
        if (buttonIndex == 1) {
            searchTerm = [alertView textFieldAtIndex:0].text;
            dispatch_queue_t imageFetchQ=dispatch_queue_create("fetch Image", NULL);
            self.searchButton.hidden = YES ;
            dispatch_async(imageFetchQ,^{
                // NSLog(searchTerm);
                //MiraBug
                //PFObject *courseObject = [CourseDataFetcher fetchCourse:searchTerm];
                
                // NSArray *assignments = [CourseDataFetcher fetchAssignments:courseObject];
                OmniRemindCourse *searchedCourse = [[OmniRemindCourse alloc] initWithDefaultValue];
                //searchedCourse = nil;
                dispatch_async(dispatch_get_main_queue(),^{
                    if (searchedCourse) {
                        [self showSearchedCourse:searchedCourse];
                    }
                    
                    else {
                        [self didNotFindCourse];
                    }
                });
                
            });
        }
        else {
            [self addSearchButton];
            
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
    [myAlertView show];
    [self addSearchButton];
    

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
    
    
    
    int height = 40;
    for (int i = 0; i < numberOfProperties; i++) {
        objc_property_t property = propertyArray[i];
        NSString *propertyName = [[NSString alloc] initWithUTF8String:property_getName(property)];
        id propertyValue = [searchedCourse valueForKey:propertyName];
        NSString *courseInfo = [NSString stringWithFormat:@"%@ : %@",propertyName,propertyValue];
        
        if ([propertyName isEqualToString:@"courseDescription"]) {
            UITextView *courseDescriptionLabel = [[UITextView alloc] initWithFrame:CGRectMake(20, height+i*COURSE_INFO_HEIGHT, 280, COURSE_INFO_HEIGHT)];
            courseDescriptionLabel.text = courseInfo;
            courseDescriptionLabel.editable = NO;
            courseDescriptionLabel.textContainer.lineFragmentPadding = 0;
            [self.addClassView addSubview:courseDescriptionLabel];

        }
        else{
            UILabel *courseInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, height+i*COURSE_INFO_HEIGHT, 280, COURSE_INFO_HEIGHT)];
            courseInfoLabel.text = courseInfo ;
            courseInfoLabel.backgroundColor = [UIColor clearColor];
            courseInfoLabel.font = [UIFont systemFontOfSize:12];
            courseInfoLabel.lineBreakMode = NSLineBreakByWordWrapping;
            courseInfoLabel.numberOfLines = 0;
            //[courseInfoLabel sizeToFit];
            [self.addClassView addSubview:courseInfoLabel];
        }
        
    }
    
    
}

- (IBAction)searchCourse:(id)sender {
    [self showCourseSearchAlert];
}

- (void)addSearchButton{
    self.searchButton.hidden = NO;
}

#pragma mark - Segue
//transfer the Image to the next view
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self performSegueWithIdentifier:@"seeDayView" sender:collectionView];
//}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *addType = @"";
    if ([segue.identifier isEqualToString:@"addRepeat"]) {
        addType = @"Repeat";
        
    }
    else{
        addType = @"Reminder";
    }
    
    OmniRemindAddDetailViewController *destViewController = segue.destinationViewController;
    destViewController.title = addType;
    
}



@end
