//
//  Constants.h
//  CampusCrawler
//
//  Created by James Lubowich on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCustomButtonHeight	30.0
#define kCurrentSection 0
#define kPastSection 1

#define kSpecialsSection 0
#define kDescriptionSection 1
#define kContactSection 2


#define kAddressRow 0
#define kWebsiteRow 1
#define kFacebookId 754465610

extern NSString * const reachabilityString;
extern NSString * const serverString;
extern NSString * const eventsRequestString;
extern NSString * const publicEventsRequestString;
extern NSString * const barRequestString;
extern NSString * const barsForEventRequestString;
extern NSString * const feedbackString;
extern BOOL useServer;

@interface Constants : NSObject {
    
}

@end
