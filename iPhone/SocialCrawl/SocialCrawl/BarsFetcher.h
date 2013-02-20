//
//  BarsFetcher.h
//  CampusCrawler
//
//  Created by James Lubowich on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataFetcher.h"
@class Bar;
@interface BarsFetcher : DataFetcher<NSXMLParserDelegate> {
    NSXMLParser *parser;
    NSMutableDictionary *barsDictionary;
    NSMutableString *currentStringValue;
    Bar *currentBar;
    NSURL *serverURL;
}

@end
