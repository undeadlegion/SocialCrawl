//
//  EventBarsFetcher.h
//  CampusCrawler
//
//  Created by James Lubowich on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
