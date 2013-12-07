//
//  SocialCrawlAppDelegate.m
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "SocialCrawlAppDelegate.h"
#import "BarsFetcher.h"
#import "BarsForEventFetcher.h"
#import "EventsFetcher.h"
#import "Bar.h"
#import "Event.h"
#import "BarForEvent.h"
#import "Reachability.h"
#import "DataFetcher.h"

@interface SocialCrawlAppDelegate () {
    
}
@end

@implementation SocialCrawlAppDelegate


#pragma mark - App Delegate -
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [TestFlight takeOff:@"4326d680-cde2-442e-86c9-28b7bd2027a9"];
    (void)[[KCSClient sharedClient] initializeKinveyServiceForAppKey:@"kid_TP78-NOrHM"
                                                 withAppSecret:@"e319aea558bb46ec89e3d0328ab42b6f"
                                                  usingOptions:nil];
    [KCSPing pingKinveyWithBlock:^(KCSPingResult *result) {
        if (result.pingWasSuccessful == YES){
            NSLog(@"Kinvey Ping Success");
        } else {
            NSLog(@"Kinvey Ping Failed");
        }
    }];
    [TestFlight passCheckpoint:@"Launched App"];
    NSLog(@"Registering for remote notifications");
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(barsFinishedLoading:) name:@"barsforid" object:nil];

    
    // if logout is enabled - defaults to NO
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:[NSDictionary dictionaryWithObject:@"NO" forKey:@"Logout"]];

    if([defaults boolForKey:@"Logout"]){
        [defaults removeObjectForKey:@"Access Token"];
        [defaults removeObjectForKey:@"Expiration Date"];
        [defaults setBool:NO forKey:@"Logout"];
        [defaults synchronize];
    }
    // set unique user id
    if (![defaults stringForKey:@"UserId"]) {
        NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [defaults setValue:uuid forKey:@"UUID"];
        [defaults synchronize];
        self.userId = [defaults stringForKey:@"UUID"];
        NSLog(@"UserId not loaded. Generating a new one:%@", self.userId);
    } else {
        self.userId = [defaults stringForKey:@"UUID"];
        NSLog(@"UserId loaded from defaults:%@", self.userId);
    }
    
    
    // load from server
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.name = @"Loading Queue";
    NSOperation *loadBars, *loadEvents;
    loadBars = [self loadFromServer:@{@"type":@"barsforid"}];
    [queue addOperation:loadBars];
//    loadEvents = [self loadFromServer:@{@"type":@"eventsforid"}];
//    [queue addOperation:loadEvents];
    
    //check if opened by an notification
    UILocalNotification *notif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if(notif != nil){
        NSLog(@"App opened by Notifciation in DidFinishLaunching");
        //        [self scheduleAlertsWithNotification:notif];
    }
    
    //hack for testing event
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    return YES;
}

// Handle the notificaton when the app is running
- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
    NSLog(@"Did Receive Local Notification %@",notif);
    NSLog(@"Notifications before: %d", [[[UIApplication sharedApplication] scheduledLocalNotifications] count]);
    [[UIApplication sharedApplication] cancelLocalNotification:notif];
    NSLog(@"Notifications after: %d", [[[UIApplication sharedApplication] scheduledLocalNotifications] count]);
    NSString *message = [notif.userInfo objectForKey:@"Message"];
    [self showAlert:message withTitle:@"Campus Crawler"];
    
    //schedule alerts for the bars
    if([[notif.userInfo objectForKey:@"Type"] isEqualToString:@"Event Start"]){
        //decrement the badge number
        
        //        Event *scheduledEvent = [NSKeyedUnarchiver unarchiveObjectWithData:[notif.userInfo objectForKey:@"Event Data"]];
        //        [self scheduleBarAlertsForEvent:scheduledEvent];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%s", __FUNCTION__);
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    NSLog(@"%s", __FUNCTION__);
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[FBSession activeSession]];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"%s", __FUNCTION__);
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActiveWithSession:[FBSession activeSession]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self.session close];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"barsforid" object:nil];
}


#pragma mark - Utility Methods -
- (NSOperation *)loadFromServer:(id)theData {
    NSString *dataPath = @"";
    DataFetcher *dataFetcher;
    NSURL *serverURL = [NSURL URLWithString:serverString];
    
    if (![theData isKindOfClass:[NSDictionary class]]){
        NSLog(@"Trying to load unknown data from server");
        return nil;
    }
    if(![self isReachable]){
        [self showAlert:@"Network Connection Unavailable" withTitle:@"Connection Error"];
        return nil;
    }
    NSDictionary *data = (NSDictionary *) theData;
    NSString *dataType = data[@"type"];
    NSString *dataId = data[@"id"];
    if ([dataType isEqualToString:@"barsforid"]) {
        dataFetcher = [[BarsFetcher alloc] init];
        dataPath = barsForIdRequestString;
    }
    if ([dataType isEqualToString:@"eventsforid"]) {
        dataFetcher = [[EventsFetcher alloc] init];
        dataPath = [eventsForIdRequestString stringByAppendingFormat:@"%@&uid=%@", self.fbId, self.userId];
    }
    if ([dataType isEqualToString:@"barsforevent"]) {
        dataFetcher = [[BarsForEventFetcher alloc] init];
        dataPath = [barsForEventRequestString stringByAppendingString:dataId];
    }
    if ([dataType isEqualToString:@"eventwithshortid"]) {
        dataFetcher = [[EventsFetcher alloc] init];
        dataPath = [eventWithShortIdRequestString stringByAppendingFormat:@"%@&uid=%@", dataId, self.userId];
    }
    
    
    if (!useServer){
        dataPath = [[NSBundle mainBundle] pathForResource:dataType ofType:@"xml"];
    }
    
    // asynchronously load from server
    __block NSDictionary *dataFromServer;
    NSBlockOperation *theOp = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"Server:  %@ from server", dataType);
        NSLog(@"\t%@%@", serverURL,dataPath);
        dataFromServer = [dataFetcher fetchDataFromPath:dataPath relativeTo:serverURL isURL:useServer];
        NSLog(@"Server: Loaded %@ from server", dataType);
    }];
    // post completion notification on main thread
    [theOp setCompletionBlock:^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:dataType object:self userInfo:dataFromServer];
        });
    }];
    return theOp;
}

- (void)createEvent:(Event *)event
{
    [self sendAsJSON:[event serializeAsDictionary]];
}
- (void)editEvent:(Event *)event
{
    [self sendAsJSON:[event serializeAsEditedDictionary]];
}
- (void)sendAsJSON:(NSDictionary *)jsonDict
{
    NSLog(@"JSON Dictionary: %@", jsonDict);

    NSURL *serverURL = [NSURL URLWithString:serverString];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:serverURL];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *accessToken = FBSession.activeSession.accessTokenData.accessToken;
    [manager.requestSerializer setAuthorizationHeaderFieldWithToken:accessToken];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [manager POST:createEventString parameters:jsonDict success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Success!");
        NSLog(@"%@", task);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Failure");
        NSLog(@"%@", error);
    }];
}
- (void)barsFinishedLoading:(NSNotification *)notification {
    self.barsDictionary = notification.userInfo;
}

- (BOOL)isReachable {
    Reachability *r = [Reachability reachabilityWithHostName:reachabilityString];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    if(internetStatus == NotReachable) {
        return NO;
    }
    return YES;
}

- (void) showAlert:(NSString*)pushmessage withTitle:(NSString*)title
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:pushmessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

@end
