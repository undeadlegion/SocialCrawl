//
//  FeedbackViewController.h
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UITableViewController <UITextViewDelegate> {
    CGRect keyboardBounds;
}
@property (nonatomic, weak) IBOutlet UITextView *feedbackView;

- (void)scrollViewToCenterOfScreen:(UIView *)theView; 
- (void)turnOffActivityIndicator:(NSTimer *)timer;

@end
