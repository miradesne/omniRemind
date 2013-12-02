//
//  OmniRemindAddDetailViewController.m
//  omniRemind
//
//  Created by Mira Chen on 11/25/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "OmniRemindAddDetailViewController.h"
#import "OmniRemindAddViewController.h"
#define REPEAT_BY_KEY @"repeatBy"
#define REPEAT_END_KEY @"repeatEnd"
#define REPEAT_START_KEY @"repeatStart"
#define REPEAT_TYPE_KEY @"repeatType"
@interface OmniRemindAddDetailViewController ()

@property (strong,nonatomic) NSMutableDictionary *repeatDict;
@property (weak, nonatomic) IBOutlet UIButton *repeatButton;
@property (weak, nonatomic) IBOutlet UITextField *startDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *endDateTextField;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIDatePicker *timePicker;

@end

@implementation OmniRemindAddDetailViewController

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

- (void)viewDidAppear:(BOOL)animated{
    [self initializeRepeatData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIDatePicker*) datePicker{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc]init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }
    return _datePicker;
}

- (void)extraSetup{
    
    [self addDatePicker:YES forInput:self.startDateTextField];
    [self addDatePicker:YES forInput:self.endDateTextField];
    
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

#pragma mark - selectActions
- (IBAction)selectRepeatType:(id)sender {
    UIActionSheet *selectTypeActionSheet = [[UIActionSheet alloc]initWithTitle:@"Repeats:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"No Repeat",@"Daily",@"Weekly",@"Monthly", nil];
    selectTypeActionSheet.tag = 100;
    [selectTypeActionSheet showInView:self.view];
    
}



#define NO_REPEAT 0
#define REPEAT_DAILY 1
#define REPEAT_WEEKLY 2
#define REPEAT_MONTHLY 3

#define MONDAY @"monday"
#define TUESDAY @"tuesday"
#define WEDNESDAY @"wednesday"
#define THURSDAY @"thursday"
#define FRIDAY @"friday"
#define SATURDAY @"saturday"
#define SUNDAY @"sunday"

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        switch (buttonIndex) {
            case 0:
                [self.repeatDict setValue:@(NO_REPEAT) forKey:REPEAT_TYPE_KEY];
                [self.repeatButton setTitle:@"No Repeat" forState:UIControlStateNormal];
                break;
                
            case 1:
                [self.repeatDict setValue:@(REPEAT_DAILY) forKey:REPEAT_TYPE_KEY];
                [self.repeatButton setTitle:@"Repeat Daily" forState:UIControlStateNormal];
                break;
                
            case 2:
                [self.repeatDict setValue:@(REPEAT_WEEKLY) forKey:REPEAT_TYPE_KEY];
                [self.repeatButton setTitle:@"Repeat Weekly" forState:UIControlStateNormal];
                break;
                
            case 3:
                [self.repeatDict setValue:@(REPEAT_MONTHLY) forKey:REPEAT_TYPE_KEY];
                [self.repeatButton setTitle:@"Repeat Monthly" forState:UIControlStateNormal];
                break;
            
            default:
                NSLog(@"default");
                break;
        }
    }
}

- (void)initializeRepeatData{
    NSDictionary *weeklyRepeatDictionary = @{MONDAY: @0,TUESDAY:@0,WEDNESDAY:@0,THURSDAY:@0,FRIDAY:@0,SATURDAY:@0,SUNDAY:@0};
    self.repeatDict = [[NSMutableDictionary alloc]initWithDictionary:@{REPEAT_TYPE_KEY:@0,REPEAT_BY_KEY:weeklyRepeatDictionary,REPEAT_END_KEY:[NSDate date],REPEAT_START_KEY:[NSDate date]}];
    
}


#pragma mark -inputSelection


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    
    
    
    if ([textField.inputView isKindOfClass:[UIDatePicker class]]) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSString *theDate;
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        theDate = [dateFormat stringFromDate:self.datePicker.date];
        textField.text = [NSString stringWithFormat:@"%@",theDate];
        if (textField == self.startDateTextField) {
            [self.repeatDict setObject:textField.text forKey:REPEAT_START_KEY];
            
        }
        else{
            [self.repeatDict setObject:textField.text forKey:REPEAT_END_KEY];
            
        }
        
    }
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)finishedSetting:(id)sender {
    
    OmniRemindAddViewController *addController = (OmniRemindAddViewController*)[self backViewController];
    if ([self.repeatDict[REPEAT_TYPE_KEY]  isEqual: @(NO_REPEAT)]) {
        self.repeatDict = nil;
    }
    addController.repeatDict = self.repeatDict;
    NSLog(@"%@",self.repeatDict);
    [self.navigationController popViewControllerAnimated:YES];
}



@end
