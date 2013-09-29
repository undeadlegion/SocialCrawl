//
//  InviteFacebookFriendsViewController.m
//  SocialCrawl
//
//  Created by James Lubo on 9/23/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "SelectFriendsViewController.h"
#import "SocialCrawlAppDelegate.h"
#import "SelectBarsViewController.h"
#import "InviteContactFriendsViewController.h"

@interface SelectFriendsViewController ()
@property (strong, nonatomic) FBFriendPickerViewController *friendPicker;
@end

@implementation SelectFriendsViewController

- (FBFriendPickerViewController *)friendPicker
{
    if (!_friendPicker) {
        _friendPicker = [[FBFriendPickerViewController alloc] init];
    }
    return _friendPicker;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)showFriendPicker
{
    self.friendPicker.title = @"Invite Friends";
    self.friendPicker.delegate = self;
    self.friendPicker.cancelButton = nil;
    self.friendPicker.doneButton = nil;
    self.friendPicker.allowsMultipleSelection = YES;
    self.friendPicker.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonPressed:)];
    [self.friendPicker loadData];
    

    [self.navigationController pushViewController:self.friendPicker animated:YES];
}

- (void)friendPickerViewControllerDataDidChange:(FBFriendPickerViewController *)friendPicker
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker
{
    NSLog(@"%s", __FUNCTION__);
}

- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id <FBGraphUser>)user
{
    return YES;
}

- (void)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                       handleError:(NSError *)error
{
    NSLog(@"Error:%@", error);
}

- (IBAction)inviteFromFacebookSelected:(id)sender
{
    NSLog(@"%s", __FUNCTION__);

    if (!FBSession.activeSession.isOpen) {
        [FBSession openActiveSessionWithReadPermissions:nil
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error) {
                                          if (error) {
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                  message:error.localizedDescription
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];
                                          } else if (session.isOpen) {
                                              [self showFriendPicker];
                                          }
                                      }];

    } else {
        [self showFriendPicker];
    }
}

- (void)facebookViewControllerDoneWasPressed:(id)sender
{
}

- (void)nextButtonPressed:(id)sender
{
    self.createdEvent.selectedFriends = self.friendPicker.selection;
    [self performSegueWithIdentifier:@"SelectBars" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // added friends from facebook
//    if ([sender isKindOfClass:[SelectFriendsViewController class]]) {
    if ([segue.identifier isEqualToString:@"SelectBars"]) {
        SelectBarsViewController *viewController = [segue destinationViewController];
        viewController.createdEvent = self.createdEvent;
    // skipped friend selection
//    } else if ([sender isKindOfClass:[UIBarButtonItem class]]) {
    } else if ([segue.identifier isEqualToString:@"InviteContacts"]) {
        InviteContactFriendsViewController *viewController = [segue destinationViewController];
        viewController.createdEvent = self.createdEvent;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
