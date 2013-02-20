//
//  EventGuestsViewController.h
//  CampusCrawler
//
//  Created by Dan  Kaufman on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocialCrawlAppDelegate.h"

#define ATTENDING 0
#define MAYBE_ATTENDING 1
#define NOT_ATTENDING 2
#define AWAITING_REPLY 3

@interface EventGuestsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    BOOL retrievedResults;
    NSArray *alphabet;
    
    NSArray *guests;
    NSArray *guestSectionSizes;
    NSArray *guestIndices;
    
    UITableView *myTableView;
    UIActivityIndicatorView *spinner;
    UILabel *loadingLabel;
    
    NSString *eventID;
    
    NSInteger guestType;
}

@property (nonatomic, strong) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) NSArray *alphabet;
@property (nonatomic, strong) NSArray *guests;
@property (nonatomic, strong) NSArray *guestSectionSizes;
@property (nonatomic, strong) NSArray *guestIndices;
@property (nonatomic, strong) NSString *eventID;
@property (nonatomic) NSInteger guestType;

- (void)populateGuestsSectionAndIndices:(NSArray*)sortedGuests;
- (void)setTitleFromGuestType;

@end
