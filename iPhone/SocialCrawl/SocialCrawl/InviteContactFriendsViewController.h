//
//  InviteFriendsViewController.h
//  SocialCrawl
//
//  Created by James Lubo on 8/26/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface InviteContactFriendsViewController : UITableViewController
@property (nonatomic, strong) Event *createdEvent;
@property (nonatomic, strong) NSMutableArray *contactFriends;
@property (nonatomic, strong) NSMutableArray *facebookFriends;
@property (nonatomic, strong) NSMutableArray *selectedFriends;
@end
