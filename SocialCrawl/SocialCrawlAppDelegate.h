//
//  SocialCrawlAppDelegate.h
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <TestFlight.h>
#import <KinveyKit/KinveyKit.h>
#import <TouchJSON/CJSONSerializer.h>
#import <TouchJSON/CJSONDeserializer.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@class Event;

@interface SocialCrawlAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDictionary *barsDictionary;
@property (strong, nonatomic) FBSession *session;
@property (copy, nonatomic) NSString *fbId;

- (void)showAlert:(NSString*)pushmessage withTitle:(NSString*)title;
- (BOOL)isReachable;
- (NSOperation *)loadFromServer:(id)data;
- (void)createEvent:(Event *)event;
- (void)sendAsJSON:(NSDictionary *)jsonDict;

@end
