//
//  EventCommentsViewController.h
//  CampusCrawler
//
//  Created by Dan  Kaufman on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WallPost.h"
#import "SocialCrawlAppDelegate.h"

@interface EventCommentsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    UITableViewCell *wallPostCell;
    WallPost *wallPost;
    
    BOOL retrievedResults;
    
    UITableView *myTableView;
    UIActivityIndicatorView *spinner;
    UILabel *loadingLabel;
}

@property (nonatomic, strong) IBOutlet UITableViewCell *wallPostCell;
@property (nonatomic, strong) IBOutlet WallPost *wallPost;
@property (nonatomic, strong) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;

- (void)loadComments;

@end
