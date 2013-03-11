//
//  ExistingEventViewController.m
//  SocialCrawl
//
//  Created by James Lubo on 3/9/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "ExistingEventViewController.h"
#import "SocialCrawlAppDelegate.h"

@interface ExistingEventViewController ()

@end

@implementation ExistingEventViewController

- (void)pressedEnter
{
    SocialCrawlAppDelegate *delegate = (SocialCrawlAppDelegate *)[UIApplication sharedApplication].delegate;
    NSOperation *loadOperation = [delegate loadFromServer:@{@"type":@"events", @"id":self.eventId}];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.name = @"Events Loader";
    [queue addOperation:loadOperation];

    // timer to shut off actiivy indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(turnOffActivityIndicator:) userInfo:nil repeats:NO];
}

- (void)turnOffActivityIndicator:(NSTimer *)theTimer
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark UITextViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self.textView becomeFirstResponder];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        
        self.eventId = textView.text;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
      
        [self pressedEnter];
        return NO;
    }
    return YES;
    
}
@end
