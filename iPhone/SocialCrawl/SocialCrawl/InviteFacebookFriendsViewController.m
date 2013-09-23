//
//  InviteFacebookFriendsViewController.m
//  SocialCrawl
//
//  Created by James Lubo on 9/23/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "InviteFacebookFriendsViewController.h"
#import <FacebookSDK.h>

@interface InviteFacebookFriendsViewController ()
@property (strong, nonatomic) FBFriendPickerViewController *friendPicker;
@end

@implementation InviteFacebookFriendsViewController

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
//    self.friendPicker.title = @"Invite Friends";
    [self.friendPicker loadData];
//    [self.navigationController pushViewController:self.friendPicker animated:NO];
    [self.friendPicker presentModallyFromViewController:self animated:NO handler:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
