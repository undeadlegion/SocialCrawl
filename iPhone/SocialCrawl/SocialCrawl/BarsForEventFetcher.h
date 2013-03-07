//
//  EventBarsFetcher.h
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataFetcher.h"
@class BarForEvent;
@class Event;

@interface BarsForEventFetcher : DataFetcher<NSXMLParserDelegate> {
    NSXMLParser *parser;
    NSMutableArray *barsForEventList;
    NSMutableString *currentStringValue;
    BarForEvent *currentBarForEvent;
    NSURL *serverURL;
    NSDateFormatter *dateFormatter;
    NSUInteger dateId;
}
- (NSDictionary *)fetchDataFromPath:(NSString *)path relativeTo:(NSURL *)baseURL isURL:(BOOL)url;
- (void)parseXMLFile:(NSString *)pathToFile relativeTo:(NSURL *)baseURL isURL:(BOOL)url;

@property (nonatomic, strong) Event *currentEvent;
@property (nonatomic, strong) NSDateComponents *currentEventDateComponents;

@end
