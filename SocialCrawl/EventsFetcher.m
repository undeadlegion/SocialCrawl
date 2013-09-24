//
//  EventsFetcher.m
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "EventsFetcher.h"
#import "Event.h"

@implementation EventsFetcher

- (id)init{
    if((self = [super init])){
        serverURL = [[NSURL alloc] initWithString:serverString];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    }
    return self;
}

- (NSDictionary *)fetchDataFromPath:(NSString *)path relativeTo:(NSURL *)baseURL isURL:(BOOL)url{
    eventsList = [[NSMutableArray alloc] init];
    [self parseXMLFile:path relativeTo:baseURL isURL:url];
    return @{@"0":eventsList};
}

#pragma mark - XML Parsing

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString:@"Event"]){
        currentEvent = [[Event alloc] init];
        currentEvent.eventId = [NSString stringWithString:[attributeDict objectForKey:@"id"]];
        NSLog(@"EventId: %@", currentEvent.eventId);
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if([elementName isEqualToString:@"Event"]) {
        [eventsList addObject:currentEvent];
        currentEvent = nil;
    }
    if([elementName isEqualToString:@"creatorid"]){
        currentEvent.creatorId = currentStringValue;
    }
    if([elementName isEqualToString:@"date"]){
        currentEvent.date = [dateFormatter dateFromString:currentStringValue];
    }
    if([elementName isEqualToString:@"dateid"]){
        currentEvent.dateId = currentStringValue;
    }
    if([elementName isEqualToString:@"title"]){
        currentEvent.title = currentStringValue;
    }
    if([elementName isEqualToString:@"description"]){
        currentEvent.description = currentStringValue;
    }
    if([elementName isEqualToString:@"picture"]){
        NSURL *imageURL = [NSURL URLWithString:currentStringValue relativeToURL:serverURL];
        NSData *data = [NSData dataWithContentsOfURL:imageURL];
        currentEvent.eventImage = [UIImage imageWithData:data];
    }
    if([elementName isEqualToString:@"privacy"]){
        currentEvent.privacy = [currentStringValue boolValue];
    }
    
    currentStringValue = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!currentStringValue) {
        currentStringValue = [[NSMutableString alloc] initWithCapacity:50];
    }
    if([string hasPrefix:@"\n"])
        return;
    [currentStringValue appendString:string];
    
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
