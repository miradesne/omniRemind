//
//  OmniRemindDayViewController.h
//  omniRemind
//
//  Created by Mira Chen on 11/5/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface OmniRemindDayViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) NSIndexPath *indexPath;
@property (nonatomic,weak) NSDate *date ;
@end
