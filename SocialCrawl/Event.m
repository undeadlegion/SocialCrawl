//
//  Event.m
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "Event.h"
#import "BarForEvent.h"

@implementation Event

- (NSDate *)date
{
    if (!_date) {
        _date = [NSDate date];
    }
    return _date;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super init])){
        _eventId = [aDecoder decodeObjectForKey:@"eventId"];
        _creatorId = [aDecoder decodeObjectForKey:@"creatorId"];
        _dateId = [aDecoder decodeObjectForKey:@"dateId"];
        _date = [aDecoder  decodeObjectForKey:@"date"];
        _title = [aDecoder  decodeObjectForKey:@"title"];
        _description = [aDecoder decodeObjectForKey:@"description"];
        _eventImage = [aDecoder decodeObjectForKey:@"eventImage"];
        _privacy = [aDecoder decodeBoolForKey:@"privacy"];
        _barsForEvent = [aDecoder decodeObjectForKey:@"barsForEvent"];
        _selectedFriends = [aDecoder decodeObjectForKey:@"selectedFriends"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_eventId forKey:@"eventId"];
    [aCoder encodeObject:_creatorId forKey:@"creatorId"];
    [aCoder encodeObject:_dateId forKey:@"dateId"];
    [aCoder encodeObject:_date forKey:@"date"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_description forKey:@"description"];
    [aCoder encodeObject:_eventImage forKey:@"eventImage"];
    [aCoder encodeBool:_privacy forKey:@"privacy"];
    [aCoder encodeObject:_barsForEvent forKey:@"barsForEvent"];
    [aCoder encodeObject:_selectedFriends forKey:@"selectedFriends"];
}

- (BOOL)isPast
{
    //get the days and hours between now and the event
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSDayCalendarUnit| NSHourCalendarUnit;
    NSDateComponents *dateComps = [calendar components:unitFlags fromDate:[NSDate date] toDate:self.date options:0];
    int years = [dateComps year];
    int months = [dateComps month];
    int days = [dateComps day];
    
    //past event
    if(days < 0 && years != 0 && months != 0)
        return YES;
    else return NO;
}

@end
