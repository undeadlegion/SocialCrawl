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

    if ([dataType isEqualToString:@"bars"]) {
        dataFetcher = [[BarsFetcher alloc] init];
        dataPath = barRequestString;
    }
    if ([dataType isEqualToString:@"events"]) {
        dataFetcher = [[EventsFetcher alloc] init];
        dataPath = [eventsRequestString stringByAppendingString:[@(kFacebookId) stringValue]];
    }
    if ([dataType isEqualToString:@"barsforevent"]) {
        dataFetcher = [[BarsForEventFetcher alloc] init];
        dataPath = [barsForEventRequestString stringByAppendingString:dataId];
    }
    
    if (!useServer){
        dataPath = [[NSBundle mainBundle] pathForResource:dataType ofType:@"xml"];
    }
    
    // asynchronously load from server
    __block NSDictionary *dataFromServer;
    NSBlockOperation *theOp = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"Server:  %@ from server", dataType);
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

#pragma mark - App Delegate -
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(barsFinishedLoading:) name:@"bars" object:nil];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // when the user hasn't set the setting it will be NO
    [defaults registerDefaults:[NSDictionary dictionaryWithObject:@"NO" forKey:@"Logout"]];
    
    // if logout is enabled
    if([defaults boolForKey:@"Logout"]){
        [defaults removeObjectForKey:@"Access Token"];
        [defaults removeObjectForKey:@"Expiration Date"];
        [defaults removeObjectForKey:@"UserId"];
        [defaults setBool:NO forKey:@"Logout"];
        [defaults synchronize];
    }

    // load from server
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.name = @"Loading Queue";
    
    NSOperation *loadBars, *loadEvents;
    loadBars = [self loadFromServer:@{@"type":@"bars"}];
//    loadEvents = [self loadFromServer:@{@"type":@"events"}];
    [queue addOperation:loadBars];
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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return NO;
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

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bars" object:nil];
}

@end
