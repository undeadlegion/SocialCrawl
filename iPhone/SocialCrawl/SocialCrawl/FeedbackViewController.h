//
//  FeedbackViewController.h
//  CampusCrawler
//
//  Created by James Lubowich on 4/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
