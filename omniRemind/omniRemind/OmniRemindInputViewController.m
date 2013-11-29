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
    UIView *targetView = [self.view viewWithTag:109];
    [targetView addGestureRecognizer:tap];
    [self extraSetup];
    
}

- (void)extraSetup{
    
}

# pragma mark - input
- (void)dismissKeyboard{
    [self.view endEditing:YES];
    
}

@end
