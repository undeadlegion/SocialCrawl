//
//  FeedbackViewController.h
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController <UITextViewDelegate> {
    CGRect keyboardBounds;
}
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UITextView *feedbackView;

- (IBAction)pressedSend:(id)sender;
- (void)scrollViewToCenterOfScreen:(UIView *)theView; 
- (void)turnOffActivityIndicator:(NSTimer *)timer;

@end
