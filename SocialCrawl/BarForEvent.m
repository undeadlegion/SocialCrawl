//
//  EventBar.m
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "BarForEvent.h"

@interface BarForEvent ()
@end

@implementation BarForEvent

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super init])){
        _barId = [aDecoder decodeObjectForKey:@"barId"];
        _time = [aDecoder decodeObjectForKey:@"time"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_barId forKey:@"barId"];
    [aCoder encodeObject:_time forKey:@"time"];
}

- (NSDictionary *)serializeAsDictionary
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZ"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];

    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];

    [keys addObject:@"bar_id"];
    [keys addObject:@"location_id"];
    [keys addObject:@"start_time"];
    [values addObject:self.barId];
    [values addObject:@(12)];
    [values addObject:[dateFormatter stringFromDate:self.time]];
    
    return [NSDictionary dictionaryWithObjects:values forKeys:keys];
}

- (BOOL)isPast
{
    if([_time compare:[NSDate date]] == NSOrderedAscending)
        return YES;
    return NO;
}

- (NSString *)description
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    return [NSString stringWithFormat:@"[BarId:%@; Time:%@; Specials:%@]", self.barId, [dateFormatter stringFromDate:self.time], self.specials];
}
@end
