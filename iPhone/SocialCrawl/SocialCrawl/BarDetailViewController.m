//
//  BarDetailViewController.m
//  CampusCrawler
//
//  Created by James Lubowich on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BarDetailViewController.h"
#import "Bar.h"

@implementation BarDetailViewController

@synthesize headerView, headerImage, headerLabel;
@synthesize currentBar, currentDateId;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    NSLog(@"View did Load");
    [super viewDidLoad];
    self.title = currentBar.name;
    self.headerImage.image = currentBar.detailedLogo;
    self.headerLabel.text = currentBar.name;
//    [self.headerImage sizeToFit];
    [self.tableView setTableHeaderView:headerView];
}

- (void)viewDidUnload
{
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == kContactSection)
        return 2;
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == kDescriptionSection)
        return @"Description";
    if(section == kContactSection)
        return @"Contact Information";
    if(section == kSpecialsSection)
        return @"Specials";
    return @"";
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    NSLog(@"HEIGHT");
//    return 50;
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kDescriptionSection) {
        return 20+[self getMessageHeight:currentBar.description];
    }
    //hack
    if (indexPath.section == kContactSection) {
        return 20+[self getMessageHeight:currentBar.address];
    }
    if (indexPath.section == kSpecialsSection) {
        return 20+[self getMessageHeight:[currentBar.specials objectForKey:currentDateId]];
    }
    else {
        NSLog(@"No other sections!");
        return 20;
    }
}


- (CGFloat)getMessageHeight:(NSString *) text {
    return [text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(270,300) lineBreakMode:UILineBreakModeWordWrap].height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    switch (indexPath.section) {
        case kDescriptionSection:
            cell.detailTextLabel.text = currentBar.description;

            break;
        case kSpecialsSection:
            cell.detailTextLabel.text = [currentBar.specials objectForKey:currentDateId];

            break;
        case kContactSection:
            if (indexPath.row == kAddressRow) {
                cell.detailTextLabel.text = currentBar.address;
            }
            if (indexPath.row == kWebsiteRow) {
                cell.detailTextLabel.text = currentBar.website;
            }
            break;
    }
    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.detailTextLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
