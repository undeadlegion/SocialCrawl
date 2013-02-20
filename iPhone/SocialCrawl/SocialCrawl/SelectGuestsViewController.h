//
//  GuestsViewController.h
//  CampusCrawler
//
//  Created by Dan  Kaufman on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ATTENDING 0
#define MAYBE_ATTENDING 1
#define NOT_ATTENDING 2
#define AWAITING_REPLY 3

@interface SelectGuestsViewController : UITableViewController {
    NSString *eventID;
}

@property (nonatomic,strong) NSString *eventID;

@end
