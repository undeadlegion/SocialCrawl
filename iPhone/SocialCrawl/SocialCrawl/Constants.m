//
//  Constants.m
//  CampusCrawler
//
//  Created by James Lubowich on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"

NSString * const reachabilityString = @"www.illinicrawler.com";
NSString * const serverString = @"http://www.illinicrawler.com/";
NSString * const eventsRequestString = @"DatabaseInteraction/DataRequest.php?type=eventsforid&id=";
NSString * const publicEventsRequestString = @"DatabaseInteraction/DataRequest.php?type=events";
NSString * const barRequestString = @"DatabaseInteraction/DataRequest.php?type=bars&id=12";
NSString * const barsForEventRequestString = @"DatabaseInteraction/DataRequest.php?type=barsforevent&id=";
NSString * const feedbackString = @"DatabaseInteraction/DataRequest.php?type=feedback&id=";
BOOL useServer = YES;

@implementation Constants

@end
