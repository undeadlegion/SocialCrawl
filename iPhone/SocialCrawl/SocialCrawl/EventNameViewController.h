//
//  EventNameViewController.h
//  SocialCrawl
//
//  Created by James Lubo on 8/24/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventNameViewController : UITableViewController <UITextViewDelegate>
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, strong) Event *createdEvent;
@end
