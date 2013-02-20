//
//  EventDetailViewController.h
//  CampusCrawler
//
//  Created by James Lubowich on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
