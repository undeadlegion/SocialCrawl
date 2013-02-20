//
//  FeedPost.h
//  CampusCrawler
//
//  Created by Dan  Kaufman on 4/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
