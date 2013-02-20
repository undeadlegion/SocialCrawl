//
//  EventBar.h
//  CampusCrawler
//
//  Created by James Lubowich on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BarForEvent : NSObject <NSCoding> {
    NSString *barId;
    NSDate *time;
    NSString *specials;
}

@property (nonatomic, copy) NSString *barId;
@property (nonatomic, copy) NSDate *time;
@property (nonatomic, copy) NSString *specials;
- (BOOL)isPast;
@end
