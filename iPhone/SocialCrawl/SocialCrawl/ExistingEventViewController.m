//
//  ExistingEventViewController.m
//  SocialCrawl
//
//  Created by James Lubo on 3/9/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "ExistingEventViewController.h"
#import "SocialCrawlAppDelegate.h"
#import "MBProgressHUD.h"

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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnOffActivityIndicator:) name:@"events" object:nil];
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.labelText = @"Loading";
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)turnOffActivityIndicator:(NSTimer *)theTimer
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    [TestFlight passCheckpoint:@"Add Existing Event"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"events" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
