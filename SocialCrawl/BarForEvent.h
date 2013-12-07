//
//  EventBar.h
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BarForEvent : NSObject <NSCoding>

@property (nonatomic, copy) NSString *barId;
@property (nonatomic, copy) NSDate *time;
@property (nonatomic, copy) NSDate *editedTime;
@property (nonatomic, copy) NSString *specials;

- (NSDictionary *)serializeAsDictionary;
- (BOOL)isPast;
@end
