//
//  FeedbackViewController.m
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "FeedbackViewController.h"
#import "SocialCrawlAppDelegate.h"


@implementation FeedbackViewController


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self  
                                             selector:@selector(keyboardNotification:)  
                                                 name:UIKeyboardWillShowNotification  
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)turnOffActivityIndicator:(NSTimer*)timer{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.feedbackView.text = @"";
}

- (void)pressedSend
{
    //start the activity indicator set a timer to turn it off
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(turnOffActivityIndicator:) userInfo:nil repeats:NO];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", serverString, feedbackString];
        urlString = [urlString stringByAppendingString:@"0"];
    urlString = [urlString stringByAppendingString:@"&message="];
    urlString = [urlString stringByAppendingString:[self.feedbackView.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSLog(@"URL:%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
        

    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];

}

- (void)keyboardNotification:(NSNotification*)notification {  
    NSDictionary *userInfo = [notification userInfo];
    NSValue *keyboardBoundsValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];  
    [keyboardBoundsValue getValue:&keyboardBounds];
}  

#pragma mark -
#pragma mark UITextViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self.feedbackView becomeFirstResponder];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
//    [self scrollViewToCenterOfScreen:textView];
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self pressedSend];
        return NO;
    }
    return YES;
    
}
- (void)scrollViewToCenterOfScreen:(UIView *)theView {  
    CGFloat viewCenterY = theView.center.y;  
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];  
    
    CGFloat availableHeight = applicationFrame.size.height - keyboardBounds.size.height;    // Remove area covered by keyboard  
    
    CGFloat y = viewCenterY - availableHeight / 2.0;  
    if (y < 0) {  
        y = 0;  
    }  
//    scrollView.contentSize = CGSizeMake(applicationFrame.size.width, applicationFrame.size.height + keyboardBounds.size.height);  
//    [scrollView setContentOffset:CGPointMake(0, y) animated:YES];
}
@end
