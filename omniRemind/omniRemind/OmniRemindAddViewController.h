//
//  OmniRemindAddViewController.h
//  omniRemind
//
//  Created by Mira Chen on 11/12/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "OmniRemindInputViewController.h"
@interface OmniRemindAddViewController : OmniRemindInputViewController<UIAlertViewDelegate>
@property (strong,nonatomic) NSDictionary *repeatDict;
@property (strong,nonatomic) NSDictionary *remindDict;
@end
