//
//  Event.m
//  CampusCrawler
//
//  Created by James Lubowich on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Event.h"
#import "BarForEvent.h"

@implementation Event
@synthesize eventId, creatorId, date, title, description, eventImage, privacy, barsForEvent;
@synthesize dateId;

- (id)initWithCoder:(NSCoder *)aDecoder{
    if((self = [super init])){
        eventId = [aDecoder decodeObjectForKey:@"eventId"];
        creatorId = [aDecoder decodeObjectForKey:@"creatorId"];
        dateId = [aDecoder decodeObjectForKey:@"dateId"];
        date = [aDecoder  decodeObjectForKey:@"date"];
        title = [aDecoder  decodeObjectForKey:@"title"];
        description = [aDecoder decodeObjectForKey:@"description"];
        eventImage = [aDecoder decodeObjectForKey:@"eventImage"];
        privacy = [aDecoder decodeBoolForKey:@"privacy"];
        barsForEvent = [aDecoder decodeObjectForKey:@"barsForEvent"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:eventId forKey:@"eventId"];
    [aCoder encodeObject:creatorId forKey:@"creatorId"];
    [aCoder encodeObject:dateId forKey:@"dateId"];
    [aCoder encodeObject:date forKey:@"date"];
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:description forKey:@"description"];
    [aCoder encodeObject:eventImage forKey:@"eventImage"];
    [aCoder encodeBool:privacy forKey:@"privacy"];
    [aCoder encodeObject:barsForEvent forKey:@"barsForEvent"];
}

- (BOOL)isPast{
//    NSLog(@"Event: %@", title);
//    NSLog(@"Today is: %@", [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
//    NSLog(@"Event date: %@", [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
//    NSLog(@"Compare: %d", [date compare:[NSDate date]]);

    //get the days and hours between now and the event
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSDayCalendarUnit| NSHourCalendarUnit;
    NSDateComponents *dateComps = [calendar components:unitFlags fromDate:[NSDate date] toDate:date options:0];
    int years = [dateComps year];
    int months = [dateComps month];
    int days = [dateComps day];
//    int hours = [dateComps hour];
    
    //past event
    if(days < 0 && years != 0 && months != 0)
        return YES;
    else return NO;
}

@end
