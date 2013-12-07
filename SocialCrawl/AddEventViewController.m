//
//  AddEventViewController.m
//  SocialCrawl
//
//  Created by James Lubo on 3/7/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "AddEventViewController.h"
#import "SocialCrawlAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Event.h"
#import "EventNameViewController.h"

@interface AddEventViewController ()

@end

@implementation AddEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)cancel:(id)sender
{
    [TestFlight passCheckpoint:@"Pressed Cancel"];
    [self.delegate addEventViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{
    [TestFlight passCheckpoint:@"Pressed Done"];
    [self.delegate addEventViewControllerDidSave:self];
}

- (IBAction)addFromFacebook:(id)sender
{
    [TestFlight passCheckpoint:@"Add From Facebook"];
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.labelText = @"Loading";
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    if (!FBSession.activeSession.isOpen) {
        [FBSession openActiveSessionWithReadPermissions:nil
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error) {
                                          if (error) {
                                              UIAlertView *alertView =
                                              [[UIAlertView alloc] initWithTitle:@"Error"
                                                                         message:error.localizedDescription
                                                                        delegate:nil
                                                               cancelButtonTitle:@"OK"
                                                               otherButtonTitles:nil];
                                              [alertView show];
                                          } else if (session.isOpen) {
                                              [self requestFbId];
                                          }
                                      }];
        
    } else {
        [self requestFbId];
    }
}

- (void)requestFbId
{
    SocialCrawlAppDelegate *appDelegate = (SocialCrawlAppDelegate *)[[UIApplication sharedApplication] delegate];
 
    if (!appDelegate.fbId && [FBSession activeSession].isOpen) {
        // get id for /me
        [FBRequestConnection startForMeWithCompletionHandler:
         ^(FBRequestConnection *connection, id result, NSError *error) {
             appDelegate.fbId = [result id];
             NSLog(@"FacebookId:%@", appDelegate.fbId);
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             [self.delegate addEventViewControllerDidSave:self];
         }];
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.delegate addEventViewControllerDidSave:self];
    }
}

- (IBAction)testEventPressed:(id)sender
{
    [self getPublishPermissions];
}

- (void)getPublishPermissions
{
    // closed so open and request permissions
    if (!FBSession.activeSession.isOpen) {
        [FBSession openActiveSessionWithPublishPermissions:@[@"create_event"]
                                           defaultAudience:FBSessionDefaultAudienceEveryone
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             if (error) {
                                                 UIAlertView *alertView =
                                                 [[UIAlertView alloc] initWithTitle:@"Error"
                                                                            message:error.localizedDescription
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                                                 [alertView show];
                                             } else if (session.isOpen) {
                                                 [self sendMockObject];
                                                 [self requestFbId];
                                                 [self.delegate addEventViewControllerDidCancel:self];
                                             }
                                         }];
        // open but no publishing permissions
    } else if (![FBSession.activeSession.permissions containsObject:@"create_event"]) {
            [[FBSession activeSession] requestNewPublishPermissions:@[@"create_event"]
                                                    defaultAudience:FBSessionDefaultAudienceEveryone
                                                  completionHandler:^(FBSession *session, NSError *error) {
                                                      if (error) {
                                                          UIAlertView *alertView =
                                                          [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                     message:error.localizedDescription
                                                                                    delegate:nil
                                                                           cancelButtonTitle:@"OK"
                                                                           otherButtonTitles:nil];
                                                          [alertView show];
                                                      } else if (session.isOpen) {
                                                          [self sendMockObject];
                                                          [self.delegate addEventViewControllerDidCancel:self];
                                                      }
                                                  }];
        // open and permissions available
    } else {
        [self sendMockObject];
        [self.delegate addEventViewControllerDidCancel:self];
    }
}

- (void)sendMockObject
{
    // send mock object for testing
    SocialCrawlAppDelegate *appDelegate = (SocialCrawlAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TestEvent" ofType:@"json"]];
    NSError *error = NULL;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    [appDelegate sendAsJSON:dict];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EventName"]) {
        [TestFlight passCheckpoint:@"Creating Event"];
        EventNameViewController *viewController = [segue destinationViewController];
        viewController.createdEvent = [[Event alloc] init];
    }
    if ([segue.identifier isEqualToString:@"AddWithId"]) {
        [TestFlight passCheckpoint:@"Add Event with ID"];        
    }
}
@end
