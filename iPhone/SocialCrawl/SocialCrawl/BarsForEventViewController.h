//
//  EventDetailViewController.h
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Event, BarForEvent, BarsForEventFetcher;

@interface BarsForEventViewController : UITableViewController

@property (nonatomic, strong) Event *currentEvent;
@property (nonatomic, copy) NSURL *serverURL;
@property (nonatomic, strong) NSDictionary *barsDictionary;
@property (nonatomic, strong) NSMutableArray *pastBars;
@property (nonatomic, strong) NSMutableArray *currentBars;
@property (nonatomic, weak) UIViewController *parentViewController;

- (void)sortBarsForEvent;
- (void)scheduleNotifications;


@end
