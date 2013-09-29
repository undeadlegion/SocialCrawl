//
//  InviteFacebookFriendsViewController.h
//  SocialCrawl
//
//  Created by James Lubo on 9/23/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "Event.h"

@interface SelectFriendsViewController : UIViewController <FBFriendPickerDelegate>
@property (nonatomic, strong) Event *createdEvent;
@end
