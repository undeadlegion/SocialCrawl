//
//  EventInfoViewController.h
//  CampusCrawler
//
//  Created by James Lubowich on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//Constants for different sections
#define EVENT_DETAILS 0
#define EVENT_GUESTS 1
#define EVENT_DESCRIPTION 2
#define EVENT_WALL 3

//Constants for different rows
#define EVENT_DATE 0
#define EVENT_TIME 1

@class Event;

@interface EventInfoViewController : UITableViewController {
    Event *currentEvent;
    NSURL *serverURL;
//    UISegmentedControl *viewToggle;
    
    NSDateFormatter *dateFormatter;
    NSDateFormatter *timeFormatter;
}
@property (nonatomic, strong) Event *currentEvent;
@property (nonatomic, copy) NSURL *serverURL;
//@property (nonatomic, retain) UISegmentedControl *viewToggle;

- (CGFloat)getMessageHeight:(NSString *)text;

@end
