//
//  ExistingEventViewController.m
//  SocialCrawl
//
//  Created by James Lubo on 3/9/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "AddWithIdViewController.h"
#import "SocialCrawlAppDelegate.h"
#import "MBProgressHUD.h"

@interface AddWithIdViewController ()

@end

@implementation AddWithIdViewController

- (void)pressedEnter
{
    [TestFlight passCheckpoint:@"Pressed Enter"];
    SocialCrawlAppDelegate *delegate = (SocialCrawlAppDelegate *)[UIApplication sharedApplication].delegate;
    NSOperation *loadOperation = [delegate loadFromServer:@{@"type":@"eventwithshortid", @"id":self.eventId}];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.name = @"Events Loader";
    [queue addOperation:loadOperation];

    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.labelText = @"Loading";
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)turnOffActivityIndicator:(NSTimer *)theTimer
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eventwithshortid" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnOffActivityIndicator:) name:@"eventwithshortid" object:nil];
    self.textView.scrollEnabled = NO;
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
