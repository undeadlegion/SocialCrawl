//
//  MyClass.h
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedPost.h"

@interface WallPost : FeedPost {
    NSString *postId;
    int numComments;
    NSArray *comments;
}

@property (nonatomic, strong) NSString *postId;
@property (nonatomic) int numComments;
@property (nonatomic, strong) NSArray *comments;

@end
