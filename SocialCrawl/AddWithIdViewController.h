//
//  ExistingEventViewController.h
//  SocialCrawl
//
//  Created by James Lubo on 3/9/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddWithIdViewController : UITableViewController<UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, strong) NSString *eventId;
@end
