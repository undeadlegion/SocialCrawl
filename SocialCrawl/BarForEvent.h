//
//  EventBar.h
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BarForEvent : NSObject <NSCoding> {
    NSString *barId;
    NSDate *time;
    NSString *specials;
}

@property (nonatomic, copy) NSString *barId;
@property (nonatomic, copy) NSDate *time;
@property (nonatomic, copy) NSString *specials;
- (BOOL)isPast;
@end
