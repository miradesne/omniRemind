//
//  OmniRemindCalendarCollectionViewCell.h
//  omniRemind
//
//  Created by Mira Chen on 11/3/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OmniRemindCalendarView.h"
@interface OmniRemindCalendarCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLabel1;
@property (weak, nonatomic) IBOutlet UILabel *eventLabel2;
@property (weak, nonatomic) IBOutlet OmniRemindCalendarView *calendarCellView;
@property (strong, nonatomic) NSDateComponents *date;
@end
