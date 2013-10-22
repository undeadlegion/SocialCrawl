//
//  Constants.m
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "Constants.h"

NSString * const reachabilityString = @"www.google.com";

#ifdef DEBUG
    NSString * const serverString = @"http://jamie.local:8888/";
#else
    NSString * const serverString = @"http://crawlwith.me/";
#endif
NSString * const createEventString = @"DatabaseInteraction/DataRequest.php";
NSString * const eventsForIdRequestString = @"DatabaseInteraction/DataRequest.php?type=eventsforid&id=";
NSString * const eventWithIdRequestString = @"DatabaseInteraction/DataRequest.php?type=eventwithid&id=";
NSString * const barsForIdRequestString = @"DatabaseInteraction/DataRequest.php?type=bars&id=12";
NSString * const barsForEventRequestString = @"DatabaseInteraction/DataRequest.php?type=barsforevent&id=";
NSString * const feedbackString = @"DatabaseInteraction/DataRequest.php?type=feedback&id=";
BOOL useServer = YES;

//NSString * const publiceventsForIdRequestString = @"DatabaseInteraction/DataRequest.php?type=events";


@implementation Constants

@end
