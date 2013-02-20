//
//  EventGuestsViewController.m
//  CampusCrawler
//
//  Created by Dan  Kaufman on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventGuestsViewController.h"

@implementation EventGuestsViewController

@synthesize myTableView, spinner, loadingLabel;
@synthesize alphabet, guests, guestSectionSizes, guestIndices;
@synthesize eventID, guestType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        alphabet = [[NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil] copy];
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
    
    [self setTitleFromGuestType];
    
    retrievedResults = NO;
    
    
    [spinner startAnimating];
    
    [NSThread detachNewThreadSelector:@selector(loadGuests) toTarget:self withObject:nil];
    
    NSString *guestRequest;
    if (guestType == ATTENDING) {
        guestRequest = [NSString stringWithFormat:@"%@/attending", eventID];
    }
    else if (guestType == MAYBE_ATTENDING) {
        guestRequest = [NSString stringWithFormat:@"%@/maybe", eventID];
    }
    else if (guestType == NOT_ATTENDING) {
        guestRequest = [NSString stringWithFormat:@"%@/declined", eventID];
    }
    else if (guestType == AWAITING_REPLY) {
        guestRequest = [NSString stringWithFormat:@"%@/noreply", eventID];
    }
}

- (void)viewDidUnload
{
    [self setSpinner:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [alphabet count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!retrievedResults) {
        return 0;
    }
    
    return [[guestSectionSizes objectAtIndex:section] intValue];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!retrievedResults) {
        return @"";
    }
    else if ([[guestSectionSizes objectAtIndex:section] intValue] == 0)
        return @"";
    else
        return [alphabet objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!retrievedResults) {
        NSLog(@"Populating Table Before Retrieving Results!");
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        return cell;
    }
    
    else {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSInteger startingIndex = [[guestIndices objectAtIndex:indexPath.section] intValue];
        
        NSString *curGuest = [guests objectAtIndex:(startingIndex+indexPath.row)];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.text = curGuest;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        return cell;
    }
}

#pragma mark - Table view delegate
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (!retrievedResults)
        return nil;
    else
        return alphabet;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index {
    return index;
}

#pragma mark - Facebook Request Calls

- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    
//    NSLog(@"Result: %@", result);
    NSMutableArray *mutableGuests = [[NSMutableArray alloc] init];
    for (NSDictionary *curGuests in [result objectForKey:@"data"]) {
        id name = [curGuests objectForKey:@"name"];
        
        [mutableGuests addObject:name];
    }
    
    guests = [[mutableGuests sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] copy];
    
    
    [self populateGuestsSectionAndIndices:guests];
    
    retrievedResults = YES;
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Request Failed. Are you logged into Facebook?");
}

#pragma mark - Instance Methods

- (void)loadGuests {
    @autoreleasepool {    
    
        NSLog(@"Requesting from facebook");
        
        while (!retrievedResults) {
//        NSLog(@"waiting...");
        }
        
        NSLog(@"Done Requesting from facebook");
        
        [myTableView reloadData];
        
//    myTableView.hidden = NO;
        [spinner stopAnimating];
        spinner.hidden = YES;
        loadingLabel.hidden = YES;
    }
}

- (void)setTitleFromGuestType {
    if (guestType == ATTENDING) {
        self.title = @"Attending";
    }
    else if (guestType == MAYBE_ATTENDING) {
        self.title = @"Maybe Attending";
    }
    else if (guestType == NOT_ATTENDING) {
        self.title = @"Not Attending";
    }
    else if (guestType == AWAITING_REPLY) {
        self.title = @"Awaiting Reply";
    }
}

- (void)populateGuestsSectionAndIndices:(NSArray*)sortedGuests {
    if ([guests count] != 0) {
        NSMutableArray *mutableGuestSectionSizes = [[NSMutableArray alloc] init];
        
        int curSection = 0;
        
        //get starting section
        NSString *firstLetter = [[guests objectAtIndex:curSection] substringToIndex:1];
        NSString *curLetter = [alphabet objectAtIndex:curSection];
        while ([firstLetter compare:curLetter] == NSOrderedDescending) {
            curSection++;
            [mutableGuestSectionSizes addObject:[NSNumber numberWithInt:0]];
            curLetter = [alphabet objectAtIndex:curSection];
        }
        
        int curIndex = 0;
        int curSectionSize = 0;
        while (curSection < [alphabet count]) {
            NSString *curLetter = [alphabet objectAtIndex:curSection];
            
            if (curIndex >= [guests count]) {
                [mutableGuestSectionSizes addObject:[NSNumber numberWithInt:curSectionSize]];
                curSection++;
            }
            
            else {
                if (curIndex+1 >= [guests count]) {
                    
                    [mutableGuestSectionSizes addObject:[NSNumber numberWithInt:curSectionSize+1]];
                    curSectionSize = 0;
                    curSection++;
                }
                
                else if ([[[guests objectAtIndex:curIndex+1] substringToIndex:1] compare:curLetter] == NSOrderedDescending) {
                    if (curSectionSize == 0) {
                        if ([[[guests objectAtIndex:curIndex] substringToIndex:1] compare:[alphabet objectAtIndex:curSection+1]] != NSOrderedSame) {
                            //only one element for letter
                            [mutableGuestSectionSizes addObject:[NSNumber numberWithInt:1]];
                        }
                        
                        else {
                            [mutableGuestSectionSizes addObject:[NSNumber numberWithInt:0]];
                            curIndex--; //don't increment index yet
                        }
                    }
                    else {
                        [mutableGuestSectionSizes addObject:[NSNumber numberWithInt:curSectionSize+1]];
                    }
                    curSection++;
                    curSectionSize = 0;
                }
                
                else {
                    curSectionSize++;
                }
                
                curIndex++;
            }
        }
        
        guestSectionSizes = [mutableGuestSectionSizes copy];
        
        //populate indices
        NSMutableArray *mutableGuestIndices = [[NSMutableArray alloc] init];
        int index = 0;
        for (int i=0; i<[guestSectionSizes count]; i++) {
            [mutableGuestIndices addObject:[NSNumber numberWithInt:index]];
            index += [[guestSectionSizes objectAtIndex:i] intValue];
        }
        
        
        guestIndices = [mutableGuestIndices copy];
    }
    else {
        NSMutableArray *mutableGuestSectionSizes = [[NSMutableArray alloc] init];
        for (int i=0; i<[alphabet count]; i++) {
            [mutableGuestSectionSizes addObject:[NSNumber numberWithInt:0]];
        }
        guestSectionSizes = [mutableGuestSectionSizes copy];
        guestIndices = [[NSArray alloc] init];
    }
}

@end
