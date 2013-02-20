//
//  MyClass.h
//  CampusCrawler
//
//  Created by Dan  Kaufman on 2/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
