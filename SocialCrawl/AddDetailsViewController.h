//
//  AddDetailsViewController.h
//  SocialCrawl
//
//  Created by James Lubo on 8/26/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/Facebook.h>
#import "Event.h"

@interface AddDetailsViewController : UITableViewController
@property (nonatomic, strong) Event *createdEvent;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UISwitch *privacyToggle;

@property (weak, nonatomic) IBOutlet UITableViewCell *privacyCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *descriptionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *dateCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *datePickerCell;
- (IBAction)dateChanged:(id)sender;

- (IBAction)doneButtonPressed:(id)sender;
@end
