//
//  Event.h
//  CampusCrawler
//
//  Created by James Lubowich on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BarForEvent;

@interface Event : NSObject<NSCoding> {
    NSString *eventId;
    NSString *creatorId;
    NSString *dateId;
    NSDate *date;
    NSString *title;
    NSString *description;
    UIImage *eventImage;
    BOOL privacy;
    NSArray *barsForEvent;
}

@property (nonatomic, copy) NSString *eventId;
@property (nonatomic, copy) NSString *creatorId;
@property (nonatomic, copy) NSString *dateId;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, strong) UIImage *eventImage;
@property (nonatomic, getter = isPrivate) BOOL privacy;
@property (nonatomic, strong) NSArray *barsForEvent;

- (BOOL)isPast;
@end
