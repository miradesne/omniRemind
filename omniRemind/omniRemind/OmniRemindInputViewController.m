//
//  OmniRemindInputViewController.m
//  omniRemind
//
//  Created by Mira Chen on 11/28/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "OmniRemindInputViewController.h"

@interface OmniRemindInputViewController ()



@end

@implementation OmniRemindInputViewController

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
    
    [self setUpInput];
}




- (void)setUpInput{
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [self extraSetup];
    
}

- (void)extraSetup{
    
}


# pragma mark - init


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


- (UIViewController *)backViewController
{
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
    if (numberOfViewControllers < 2)
        return nil;
    else
        return [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
}



@end
