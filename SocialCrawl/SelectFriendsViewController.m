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
}

- (void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker
{
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
    if (!FBSession.activeSession.isOpen) {
        [FBSession openActiveSessionWithReadPermissions:nil
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error) {
                                          if (error) {
                                              UIAlertView *alertView =
                                              [[UIAlertView alloc] initWithTitle:@"Error"
                                                                         message:error.localizedDescription
                                                                        delegate:nil
                                                               cancelButtonTitle:@"OK"
                                                               otherButtonTitles:nil];
                                              [alertView show];
                                          } else if (session.isOpen) {
                                              [self requestFbId];
                                              [self showFriendPicker];
                                          }
                                      }];

    } else {
        [self showFriendPicker];
    }
}
- (void)requestFbId
{
    SocialCrawlAppDelegate *appDelegate = (SocialCrawlAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (!appDelegate.fbId && [FBSession activeSession].isOpen) {
        // get id for /me
        [FBRequestConnection startForMeWithCompletionHandler:
         ^(FBRequestConnection *connection, id result, NSError *error) {
             appDelegate.fbId = [result id];
         }];
        
    }
}
- (void)facebookViewControllerDoneWasPressed:(id)sender
{
}

- (void)nextButtonPressed:(id)sender
{
    NSMutableArray *friendIds = [[NSMutableArray alloc] init];
    for (id<FBGraphUser> user in self.friendPicker.selection) {
        [friendIds addObject:user.id];
    }
    self.createdEvent.selectedFriends = friendIds;
    [self performSegueWithIdentifier:@"SelectBars" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // added friends from facebook
    if ([segue.identifier isEqualToString:@"SelectBars"]) {
        SelectBarsViewController *viewController = [segue destinationViewController];
        viewController.createdEvent = self.createdEvent;
    // skipped friend selection
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
