//
//  OmniRemindCalendarView.m
//  omniRemind
//
//  Created by Mira Chen on 11/2/13.
//  Copyright (c) 2013 Rice University. All rights reserved.
//

#import "OmniRemindCalendarView.h"
@interface OmniRemindCalendarView ()

@property (nonatomic,strong) NSMutableArray* events;
@end
@implementation OmniRemindCalendarView


#pragma mark -Initialization

-(NSMutableArray*)events{
    if(!_events)_events=[[NSMutableArray alloc]init];
    return _events;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//         [self setup];
    }
    return self;
}

-(void)awakeFromNib{
//    [self setup];
}

-(void)setup
{
    //do initialization here
    [self.events addObject:@"event1"];//this will be replaced by an event object
    [self.events addObject:@"event2"];
    [self.events addObject:@"event3"];
    [self updAteCalendarUI];
}

-(void)viewDidLoad{
//    [self updAteCalendarUI];
}
#define EVENT_WIDTH 50
#define EVENT_HEIGHT 20
-(void)updAteCalendarUI{
    CGFloat positionY = 0.0;
    for (NSString *event in self.events){
        UILabel *eventLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, positionY, EVENT_WIDTH, EVENT_HEIGHT)];
        eventLabel.textColor=[UIColor blackColor];
        eventLabel.backgroundColor=[UIColor clearColor];
        eventLabel.text= event;
        eventLabel.font = [eventLabel.font fontWithSize:10.0];
        eventLabel.textAlignment = NSTextAlignmentCenter;
        [eventLabel sizeToFit];
        [self addSubview:eventLabel];
        positionY+=EVENT_HEIGHT;
    }
    
}

@end
