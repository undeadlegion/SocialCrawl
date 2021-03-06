//
//  BarInfoViewController.h
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Bar;
@class BarForEvent;

@interface BarInfoViewController : UITableViewController

@property (nonatomic, strong) Bar *currentBar;
@property (nonatomic, copy) NSString *currentDateId;
@property (weak, nonatomic) IBOutlet UIImageView *headerViewImage;
@property (weak, nonatomic) IBOutlet UILabel *headerViewLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) BarForEvent *eventBar;
@property (nonatomic, assign) BOOL shouldUnwindToSelectBars;
@property (nonatomic, copy) NSDate *currentTime;
@property (nonatomic, assign) BOOL timeChanged;

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
- (BOOL)canEditEvent;

//- (CGFloat)getMessageHeight:(NSString *)text;

@end
