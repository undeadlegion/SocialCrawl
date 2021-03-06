//
//  EventNameViewController.m
//  SocialCrawl
//
//  Created by James Lubo on 8/24/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "EventNameViewController.h"
#import "SelectFriendsViewController.h"

@interface EventNameViewController ()

@end

@implementation EventNameViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView.scrollEnabled = NO;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self.textView becomeFirstResponder];
    }
}

#pragma mark -
#pragma mark UITextViewDelegate
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
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [TestFlight passCheckpoint:@"Entered Name"];
        //        [self performSegueWithIdentifier:@"SelectFriends" sender:self];
        return NO;
    }
    return YES;
    
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.createdEvent.title = self.textView.text;
    SelectFriendsViewController * viewController = [segue destinationViewController];
    viewController.createdEvent = self.createdEvent;
}

@end
