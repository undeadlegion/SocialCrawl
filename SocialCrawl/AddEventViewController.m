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
    [self.delegate addEventViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{
    [self.delegate addEventViewControllerDidSave:self];
}

- (IBAction)addFromFacebook:(id)sender
{
    SocialCrawlAppDelegate *appDelegate = (SocialCrawlAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        appDelegate.session = [[FBSession alloc] init];
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            [self.delegate addEventViewControllerDidSave:self];
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"EventName"]) {
        EventNameViewController *viewController = [segue destinationViewController];
        viewController.createdEvent = [[Event alloc] init];
    }
}
@end
