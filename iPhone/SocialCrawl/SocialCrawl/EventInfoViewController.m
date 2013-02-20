//
//  EventInfoViewController.m
//  CampusCrawler
//
//  Created by James Lubowich on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventInfoViewController.h"
#import "Event.h"
#import "BarForEvent.h"
#import "EventGuestsViewController.h"
#import "SelectGuestsViewController.h"
#import "EventWallViewController.h"

@implementation EventInfoViewController
@synthesize currentEvent, serverURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        
        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
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
    
    CGRect titleRect = CGRectMake(0, 0, 300, 40);
    UILabel *tableTitle = [[UILabel alloc] initWithFrame:titleRect];
    tableTitle.textColor = [UIColor blackColor];
    tableTitle.backgroundColor = [self.tableView backgroundColor];
    tableTitle.font = [UIFont boldSystemFontOfSize:20];
    tableTitle.textAlignment = UITextAlignmentCenter;
    tableTitle.text = currentEvent.title;
    self.tableView.tableHeaderView = tableTitle;
    
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    CGRect titleRect = CGRectMake(0, 0, 300, 40);
    UILabel *tableTitle = [[UILabel alloc] initWithFrame:titleRect];
    tableTitle.textColor = [UIColor blackColor];
    tableTitle.backgroundColor = [self.tableView backgroundColor];
    tableTitle.font = [UIFont boldSystemFontOfSize:20];
    tableTitle.textAlignment = UITextAlignmentCenter;
    tableTitle.text = currentEvent.title;
    self.tableView.tableHeaderView = tableTitle;
    
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == EVENT_DESCRIPTION) {
        return 30+[self getMessageHeight:currentEvent.description];
    }
    else
        return 45;
}

- (CGFloat)getMessageHeight:(NSString *) text {
    return [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(270,300) lineBreakMode:UILineBreakModeWordWrap].height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == EVENT_DETAILS)
        return 2;
    
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (indexPath.section == EVENT_DETAILS) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        }
        
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
        }
    }
    
    //General cell properties
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
        case EVENT_DETAILS:
            cell.accessoryType = UITableViewCellAccessoryNone;
            if (indexPath.row == EVENT_DATE) {
                cell.textLabel.text = @"date";
                cell.detailTextLabel.text = [dateFormatter stringFromDate:currentEvent.date];
            }
            
            else if (indexPath.row == EVENT_TIME) {
                cell.textLabel.text = @"time";
                if([currentEvent.barsForEvent count] > 0){
                    BarForEvent *curBar = [currentEvent.barsForEvent objectAtIndex:0];
                    NSString *startTime = [timeFormatter stringFromDate:curBar.time];
                    NSInteger lastBarIndex = [currentEvent.barsForEvent count]-1;
                    curBar = [currentEvent.barsForEvent objectAtIndex:lastBarIndex];
                    NSString *endTime = [timeFormatter stringFromDate:curBar.time];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
                }
            }
            break;
        
        case EVENT_GUESTS:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"Guests";
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            
            break;
        
        case EVENT_DESCRIPTION:
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = currentEvent.description;
            cell.textLabel.font = [cell.textLabel.font fontWithSize:14];
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.textLabel.numberOfLines = 0;
            break;
        
        case EVENT_WALL:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"Wall";
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == EVENT_DESCRIPTION)
        return @"Description";
    
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == EVENT_GUESTS) {
        SelectGuestsViewController *selectGuestsViewController = [[SelectGuestsViewController alloc] initWithNibName:@"SelectGuestsViewController" bundle:nil];
        if (useServer)
            selectGuestsViewController.eventID = currentEvent.eventId;
        else //for testing purposes
            selectGuestsViewController.eventID = @"201994573163915"; //Blackhawk Bar Crawl
        [self.navigationController pushViewController:selectGuestsViewController animated:YES];
    }
    
    else if (indexPath.section == EVENT_WALL) {
        EventWallViewController *eventWallViewController = [[EventWallViewController alloc] initWithNibName:@"EventWallViewController" bundle:nil];
        if (useServer)
            eventWallViewController.eventID = currentEvent.eventId;
        else //for testing purposes
            eventWallViewController.eventID = @"201994573163915"; //Blackhawk Bar Crawl
        [self.navigationController pushViewController:eventWallViewController animated:YES];
    }
}

@end
