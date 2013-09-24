//
//  EventsFetcher.h
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataFetcher.h"
@class Event;
@interface EventsFetcher : DataFetcher<NSXMLParserDelegate> {
    NSXMLParser *parser;
    NSMutableArray *eventsList;
    NSMutableString *currentStringValue;
    Event *currentEvent;
    NSURL *serverURL;
    NSDateFormatter *dateFormatter;
}

- (NSDictionary *)fetchDataFromPath:(NSString *)path relativeTo:(NSURL *)baseURL isURL:(BOOL)url;
- (void)parseXMLFile:(NSString *)pathToFile relativeTo:(NSURL *)baseURL isURL:(BOOL)url;

@end
