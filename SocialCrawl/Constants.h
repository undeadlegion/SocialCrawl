//
//  Constants.h
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <Foundation/Foundation.h>

// BarsForEventViewController
#define kCustomButtonHeight	30.0
#define kCurrentSection 0
#define kPastSection 1

// SelectBarsViewController
#define kSelectedSection 0
#define kOtherSection 1

// BarInfoViewController
#define kTimeSection 0
#define kSpecialsSection 1
#define kContactInfoSection 2
#define kDescriptionSection 3

#define kAddressRow 0
#define kWebsiteRow 1
#define kTimeRow 0

#define kDatePickerRow 1
#define kDatePickerRowHeight 161

// AddDetailsViewController
#define kEventDescriptionSection 0
#define kPrivacySection 1
#define kDateSection 2
#define kDateRow 0

// DrinkLoggerViewController
#define kBeerSection 0
#define kShotSection 1
#define kWineSection 2


#define kFacebookId 754465610

#define kPrivacyTypePublic @"OPEN"
#define kPrivacyTypePrivate @"FRIENDS"

extern NSString * const reachabilityString;
extern NSString * const serverString;
extern NSString * const createEventString;
extern NSString * const eventsForIdRequestString;
extern NSString * const eventWithIdRequestString;
extern NSString * const publiceventsForIdRequestString;
extern NSString * const barsForIdRequestString;
extern NSString * const barsForEventRequestString;
extern NSString * const feedbackString;
extern BOOL useServer;

@interface Constants : NSObject

@end
