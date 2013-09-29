//
//  Event.h
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BarForEvent;

@interface Event : NSObject<NSCoding>

@property (nonatomic, copy) NSString *eventId;
@property (nonatomic, copy) NSString *creatorId;
@property (nonatomic, copy) NSString *dateId;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, strong) UIImage *eventImage;
@property (nonatomic, getter = isPrivate) BOOL privacy;
@property (nonatomic, strong) NSArray *barsForEvent;
@property (nonatomic, strong) NSArray *selectedFriends;

- (BOOL)isPast;
@end
