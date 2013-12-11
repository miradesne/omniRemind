//
//  OmniRemindDayViewController.h
//  omniRemind
//
//  Created by Mira Chen on 11/5/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//
//  This class is to show the events on a day
//  Events label are calculated by the duration and how many
//  events are there in a 1hr time slot
//  The users can click the events and look for detail, which
//  is implemented by tapGesture recognizer
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface OmniRemindDayViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) NSIndexPath *indexPath;
@property (nonatomic,weak) NSDateComponents *dateComp ;
@end
