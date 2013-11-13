//
//  OmniRemindAddViewController.m
//  omniRemind
//
//  Created by Mira Chen on 11/12/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "OmniRemindAddViewController.h"

@interface OmniRemindAddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleInput;
@property (weak, nonatomic) IBOutlet UITextField *startTime;
@property (weak, nonatomic) IBOutlet UITextField *startDate;
@property (weak, nonatomic) IBOutlet UITextField *endTime;
@property (weak, nonatomic) IBOutlet UITextField *locationInput;
@property (weak, nonatomic) IBOutlet UISegmentedControl *addSegmentedControl;

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
	// Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    UIView *targetView = [self.view viewWithTag:109];
    [targetView addGestureRecognizer:tap];
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

# pragma mark - toolBar

- (IBAction)cancelCreate:(id)sender {
    self.tabBarController.selectedIndex = 0;
    
}

# pragma mark - input
- (void)dismissKeyboard{
   // [self.view removeGestureRecognizer:self.tap];
    [self.view endEditing:YES];
    
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    for (UIView * txt in self.view.subviews){
//        if ([txt isKindOfClass:[UITextField class]]) {
//            [txt resignFirstResponder];
//        }
//    }
//}

@end
