//
//  OmniRemindInputViewController.h
//  omniRemind
//
//  Created by Mira Chen on 11/28/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//
//  This is a super class for all the viewControllers that have textfield input
//  

#import <UIKit/UIKit.h>

@interface OmniRemindInputViewController : UIViewController<UITextFieldDelegate>
- (void)extraSetup;
- (UIViewController *)backViewController;
@end
