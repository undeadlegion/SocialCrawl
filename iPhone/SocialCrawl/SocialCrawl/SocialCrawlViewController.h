//
//  SocialCrawlViewController.h
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EventSegmentsController;

@interface SocialCrawlViewController : UITableViewController
@property (strong, nonatomic) EventSegmentsController *eventSegmentsController;
@property (strong, nonatomic) NSDictionary *eventsList;
@property (strong, nonatomic) NSMutableArray *currentEvents;
@property (strong, nonatomic) NSMutableArray *pastEvents;
@property (strong, nonatomic) NSDictionary *barsDictionary;
@property (strong, nonatomic) NSDate *lastUpdated;

@end
