//
//  EventBar.m
//  CampusCrawler
//
//  Created by James Lubowich on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BarForEvent.h"


@implementation BarForEvent
@synthesize barId, time, specials;

- (id)initWithCoder:(NSCoder *)aDecoder{
    if((self = [super init])){
        barId = [aDecoder decodeObjectForKey:@"barId"];
        time = [aDecoder decodeObjectForKey:@"time"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:barId forKey:@"barId"];
    [aCoder encodeObject:time forKey:@"time"];
}

- (BOOL)isPast{
    //get the days and hours between now and the event
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    unsigned unitFlags = NSDayCalendarUnit| NSHourCalendarUnit;
//    NSDateComponents *dateComps = [calendar components:unitFlags fromDate:[NSDate date] toDate:time options:0];
//    int years = [dateComps year];
//    int months = [dateComps month];
//    int days = [dateComps day];
//    int hours = [dateComps hour];
    
    //past event
//    if(days < 0 && years != 0 && months != 0)
//        return YES;
//    else return NO;
    if([time compare:[NSDate date]] == NSOrderedAscending)
        return YES;
    return NO;
}

@end
