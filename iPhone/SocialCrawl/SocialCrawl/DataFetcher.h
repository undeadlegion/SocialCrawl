//
//  DataFetcher.h
//  SocialCrawl
//
//  Created by James Lubo on 2/18/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataFetcher : NSObject

@property (strong, nonatomic) NSDictionary *dataDictionary;

- (NSDictionary *)fetchDataFromPath:(NSString *)path relativeTo:(NSURL *)baseURL isURL:(BOOL)url;
- (void)parseXMLFile:(NSString *)pathToFile relativeTo:(NSURL *)baseURL isURL:(BOOL)url;

@end
