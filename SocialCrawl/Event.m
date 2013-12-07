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
        _eventDescription = [aDecoder decodeObjectForKey:@"eventDescription"];
        _eventImage = [aDecoder decodeObjectForKey:@"eventImage"];
        _privacyType = [aDecoder decodeObjectForKey:@"privacyType"];
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
    [aCoder encodeObject:_eventDescription forKey:@"eventDescription"];
    [aCoder encodeObject:_eventImage forKey:@"eventImage"];
    [aCoder encodeObject:_privacyType forKey:@"privacyType"];
    [aCoder encodeObject:_barsForEvent forKey:@"barsForEvent"];
    [aCoder encodeObject:_selectedFriends forKey:@"selectedFriends"];
}

- (id)init
{
    self = [super init];
    if (self) {
        _eventId = @"";
        _creatorId = @"";
        _dateId = @"";
        _date = [NSDate date];
        _title = @"";
        _eventDescription = @"";
        _eventImage = [[UIImage alloc] init];
        _privacyType = kPrivacyTypePrivate;
        _barsForEvent = [[NSArray alloc] init];
        _selectedFriends = [[NSArray alloc] init];
    }
    return self;
}

- (NSDictionary *)serializeAsDictionary
{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];

    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [keys addObject:@"should_create"];
    [keys addObject:@"creator_id"];
    [keys addObject:@"start_time"];
    [keys addObject:@"name"];
    [keys addObject:@"description"];
    [keys addObject:@"privacy_type"];
    [keys addObject:@"selected_bars"];
    [keys addObject:@"invited_guests"];
    [values addObject:@"NO"];
    [values addObject:self.creatorId];
    [values addObject:[dateFormatter stringFromDate:self.date]];
    [values addObject:self.title];
    [values addObject:self.eventDescription];
    [values addObject:self.privacyType];
    
    // serialize each bar
    NSMutableArray *bars = [[NSMutableArray alloc] init];
    [self.barsForEvent enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [bars addObject:[(BarForEvent *)obj serializeAsDictionary]];
    }];
    [values addObject:bars];
    [values addObject:self.selectedFriends];

    return [NSDictionary dictionaryWithObjects:values forKeys:keys];
}
- (NSDictionary *)serializeAsEditedDictionary
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [keys addObject:@"should_create"];
    [keys addObject:@"creator_id"];
    [keys addObject:@"start_time"];
    [keys addObject:@"name"];
    [keys addObject:@"description"];
    [keys addObject:@"privacy_type"];
    [keys addObject:@"selected_bars"];
    [keys addObject:@"invited_guests"];
    [values addObject:@"NO"];
    [values addObject:self.creatorId];
    [values addObject:[dateFormatter stringFromDate:self.date]];
    [values addObject:self.title];
    [values addObject:self.eventDescription];
    [values addObject:self.privacyType];
    
    NSMutableArray *bars = [[NSMutableArray alloc] init];
    [bars addObject:[self.editedBar serializeAsDictionary]];
    [values addObject:bars];
    [values addObject:self.selectedFriends];
    
    return [NSDictionary dictionaryWithObjects:values forKeys:keys];
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

- (NSString *)description
{
    return [NSString stringWithFormat:@"[EventId:%@\nCreatorId:%@\nDateId:%@\nDate:%@\nTitle:%@\nDescription:%@\nPrivacyType:%@\nBarsForEvent:%@\nSelectedFriends%@]", self.eventId, self.creatorId, self.dateId, self.date, self.title, self.eventDescription, self.privacyType, self.barsForEvent, self.selectedFriends];
}
@end
