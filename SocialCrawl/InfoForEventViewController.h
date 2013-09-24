//
//  InfoForEventViewController.h
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
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

@interface InfoForEventViewController : UITableViewController {
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
