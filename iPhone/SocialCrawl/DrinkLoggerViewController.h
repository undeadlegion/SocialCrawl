//
//  DrinkLoggerViewController.h
//  SocialCrawl
//
//  Created by James Lubo on 3/8/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrinkLoggerViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray *beerList;
@property (strong, nonatomic) NSMutableArray *wineList;
@property (strong, nonatomic) NSMutableArray *shotList;
@end
