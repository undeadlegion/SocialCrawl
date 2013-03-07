//
//  FeedPost.h
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FeedPost : NSObject {
    NSString *name;
    NSString *message;
    NSDate *date;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSDate *date;

@end
