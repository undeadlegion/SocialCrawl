//
//  BarInfoViewController.h
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Bar;
@interface BarInfoViewController : UITableViewController

@property (nonatomic, strong) Bar *currentBar;
@property (nonatomic, copy) NSString *currentDateId;
@property (weak, nonatomic) IBOutlet UIImageView *headerViewImage;
@property (weak, nonatomic) IBOutlet UILabel *headerViewLabel;


- (CGFloat)getMessageHeight:(NSString *)text;

@end
