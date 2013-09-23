//
//  BarInfoViewController.m
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "BarInfoViewController.h"
#import "Bar.h"
#import "SelectBarsViewController.h"
#import "BarForEvent.h"

@implementation BarInfoViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.headerViewImage.image = self.currentBar.detailedLogo;
    self.headerViewLabel.text = self.currentBar.name;
    self.title = self.currentBar.name;
    self.datePicker.date = self.eventBar.time;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == kDescriptionSection)
        return @"Description";
    if(section == kContactSection)
        return @"Contact Information";
    if(section == kSpecialsSection)
        return @"Specials";
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger messageHeight;
    if (indexPath.section == kDescriptionSection) {
        messageHeight = 20+[self getMessageHeight:self.currentBar.description];
    }
    if (indexPath.section == kContactSection) {
        messageHeight = 20+[self getMessageHeight:self.currentBar.address];
    }
    if (indexPath.section == kSpecialsSection) {
        NSString *specials = [self.currentBar.specials objectForKey:self.currentDateId];
        if ([specials length] == 0)
            messageHeight = 0;
        else
            messageHeight = 20+[self getMessageHeight:[self.currentBar.specials objectForKey:self.currentDateId]];
    }
    if (messageHeight < 45)
        return 45;
    else
        return messageHeight;
}

- (IBAction)doneButtonPressed:(id)sender {
    NSLog(@"DONE BUTTON");
    self.eventBar.time = self.datePicker.date;
    [self performSegueWithIdentifier:@"unwindToSelectBars" sender:self];
}

- (CGFloat)getMessageHeight:(NSString *) text
{
    return [text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(270,300) lineBreakMode:NSLineBreakByWordWrapping].height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"BarInfoCell"];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == kDescriptionSection) {
        cell.textLabel.text = self.currentBar.description;
    }
    if (indexPath.section == kSpecialsSection) {
        cell.textLabel.text = [self.currentBar.specials objectForKey:self.currentDateId];
    }
    if (indexPath.section == kContactSection) {
        if (indexPath.row == kAddressRow) {
            cell.textLabel.text = self.currentBar.address;
        }
        if (indexPath.row == kWebsiteRow) {
            cell.textLabel.text = self.currentBar.website;
        }
    }
    
    
    return cell;
}

#pragma mark - Table view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
}
@end
