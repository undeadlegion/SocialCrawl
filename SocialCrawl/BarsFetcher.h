//
//  BarsFetcher.h
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
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
