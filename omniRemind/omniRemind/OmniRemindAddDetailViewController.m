//
//  OmniRemindAddDetailViewController.m
//  omniRemind
//
//  Created by Mira Chen on 11/25/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "OmniRemindAddDetailViewController.h"

@interface OmniRemindAddDetailViewController ()

@property (strong,nonatomic) NSMutableDictionary *repeatDict;
@property (weak, nonatomic) IBOutlet UIButton *repeatButton;
@property (weak, nonatomic) IBOutlet UIButton *repeatEveryButton;
@property (weak, nonatomic) IBOutlet UITextField *startDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *afterOccurenceTextField;
@property (weak, nonatomic) IBOutlet UITextField *endDateTextField;
@property (weak, nonatomic) IBOutlet UIButton *endSelectOccurencesButton;
@property (weak, nonatomic) IBOutlet UIButton *endSelectDateButton;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - selectActions

@end
