//
//  Constants.h
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
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
