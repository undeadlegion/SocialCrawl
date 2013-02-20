//
//  EventsFetcher.h
//  CampusCrawler
//
//  Created by James Lubowich on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
