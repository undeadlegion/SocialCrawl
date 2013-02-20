//
//  GuestsViewController.m
//  CampusCrawler
//
//  Created by Dan  Kaufman on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelectGuestsViewController.h"
#import "EventGuestsViewController.h"

@implementation SelectGuestsViewController

@synthesize eventID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        eventID = @"201994573163915"; //Blackhawks Bar Crawl
//        eventID = @"102027789869923"; //Weston Bar Crawl
//        eventID = @"177706622280268"; //Test Bar Crawl
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Guests";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.section) {
        case ATTENDING:
            cell.textLabel.text = @"Attending";
            break;
        case MAYBE_ATTENDING:
            cell.textLabel.text = @"Maybe Attending";
            break;
        case NOT_ATTENDING:
            cell.textLabel.text = @"Not Attending";
            break;
        case AWAITING_REPLY:
            cell.textLabel.text = @"Awaiting Reply";
            break;
    }
    
    return cell;
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EventGuestsViewController *eventGuestsViewController = [[EventGuestsViewController alloc] initWithNibName:@"EventGuestsViewController" bundle:nil];
    
    eventGuestsViewController.eventID = eventID;
    
    if (indexPath.section == ATTENDING) {
        eventGuestsViewController.guestType = ATTENDING;
    }
    else if (indexPath.section == MAYBE_ATTENDING) {
        eventGuestsViewController.guestType = MAYBE_ATTENDING;
    }
    else if (indexPath.section == NOT_ATTENDING) {
        eventGuestsViewController.guestType = NOT_ATTENDING;
    }
    else if (indexPath.section == AWAITING_REPLY) {
        eventGuestsViewController.guestType = AWAITING_REPLY;
    }
    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:eventGuestsViewController animated:YES];
}

@end
