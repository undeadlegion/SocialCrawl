//
//  EventDetailViewController.h
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Event, BarForEvent, BarsForEventFetcher;

@interface BarsForEventViewController : UITableViewController <NSXMLParserDelegate>{

    NSDateFormatter *dateFormatter;    
    BOOL isReloading;
}

@property (nonatomic, strong) Event *currentEvent;
@property (nonatomic, copy) NSURL *serverURL;
@property (nonatomic, strong) NSDictionary *barsDictionary;
@property (nonatomic, strong) NSMutableArray *pastBars;
@property (nonatomic, strong) NSMutableArray *currentBars;
@property (nonatomic, strong) NSDate *lastUpdated;

- (void)sortBarsForEvent;
- (void)scheduleNotifications;


@end
