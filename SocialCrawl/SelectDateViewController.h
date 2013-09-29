//
//  SelectDateViewController.h
//  SocialCrawl
//
//  Created by James Lubo on 9/28/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface SelectDateViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) Event *createdEvent;

@end
