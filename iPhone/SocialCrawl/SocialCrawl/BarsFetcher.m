//
//  BarsFetcher.m
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "BarsFetcher.h"
#import "Bar.h"

@implementation BarsFetcher
#pragma mark - XML Parsing

- (id)init{
    if((self = [super init])){
        serverURL = [[NSURL alloc] initWithString:serverString];
    }
    return self;
}


- (NSDictionary *)fetchDataFromPath:(NSString *)path relativeTo:(NSURL *)baseURL isURL:(BOOL)url{
    barsDictionary = [[NSMutableDictionary alloc] init];
    [self parseXMLFile:path relativeTo:baseURL isURL:url];
    return barsDictionary;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString:@"Bar"]){
        currentBar = [[Bar alloc] init];
        currentBar.barId = [NSString stringWithString:[attributeDict objectForKey:@"id"]];
        NSLog(@"BarId: %@", currentBar.barId);
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if([elementName isEqualToString:@"Bar"]) {
        [barsDictionary setObject:currentBar forKey:currentBar.barId];
        currentBar = nil;
    }
    if([elementName isEqualToString:@"name"]){
        currentBar.name = currentStringValue;
    }
    if([elementName isEqualToString:@"address"]){
        currentBar.address = currentStringValue;
    }
    if([elementName isEqualToString:@"description"]){
        currentBar.description = currentStringValue;
    }
    if([elementName isEqualToString:@"website"]){
        currentBar.website = currentStringValue;
    }
    if([elementName isEqualToString:@"quicklogo"]){
        currentBar.quickLogoPath = currentStringValue;
        NSURL *logoURL = [NSURL URLWithString:currentStringValue relativeToURL:serverURL];
        NSData *data = [NSData dataWithContentsOfURL:logoURL];
        currentBar.quickLogo = [UIImage imageWithData:data];
    }
    if([elementName isEqualToString:@"detailedlogo"]){
        currentBar.detailedLogoPath = currentStringValue;
        NSURL *logoURL = [NSURL URLWithString:currentStringValue relativeToURL:serverURL];
        NSData *data = [NSData dataWithContentsOfURL:logoURL];
        currentBar.detailedLogo = [UIImage imageWithData:data];
    }
    if([elementName isEqualToString:@"longitude"]){
        currentBar.longitude = [currentStringValue doubleValue];
    }
    if([elementName isEqualToString:@"latitude"]){
        currentBar.latitude = [currentStringValue doubleValue];
    }

    currentStringValue = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!currentStringValue) {
        currentStringValue = [[NSMutableString alloc] initWithCapacity:50];
    }
    if([string hasPrefix:@"\n"])
        return;
    [currentStringValue appendString:[string stringByTrimmingCharactersInSet:
                                      [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}

- (void)parseXMLFile:(NSString *)pathToFile relativeTo:(NSURL *)baseURL isURL:(BOOL)url{
    BOOL success;
    NSURL *xmlURL;
    if(url)
        xmlURL = [NSURL URLWithString:pathToFile relativeToURL:baseURL];
    else
        xmlURL = [NSURL fileURLWithPath:pathToFile];
    
    
    parser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:YES];
    success = [parser parse]; // return value not used
                              // if not successful, delegate is informed of error
}

@end
