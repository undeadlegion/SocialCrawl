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

static NSString *kBarInfoCell = @"barInfoCell";
static NSString *kTimeCell = @"timeCell";
static NSString *kDatePickerCell = @"datePickerCell";

@interface BarInfoViewController ()
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic, assign) NSInteger datePickerRowHeight;
@end

@implementation BarInfoViewController

- (BOOL)hasInlineDatePicker
{
    return (self.datePickerIndexPath != nil);
}
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
    return ([self hasInlineDatePicker] && self.datePickerIndexPath.row == indexPath.row);
}
- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"h:mm a"];
    }
    return _dateFormatter;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.headerViewImage.image = self.currentBar.detailedLogo;
    self.headerViewLabel.text = self.currentBar.name;
    self.title = self.currentBar.name;
    self.currentTime = self.eventBar.time;
    if (self.shouldUnwindToSelectBars) {
        self.doneButton.title = @"Save";
    } else {
        self.doneButton.title = @"Done";
    }
}

- (IBAction)doneButtonPressed:(id)sender
{
    if (self.shouldUnwindToSelectBars) {
        self.eventBar.time = self.currentTime;
        [self performSegueWithIdentifier:@"unwindToSelectBarsSave" sender:self];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)cancelButtonPressed:(id)sender
{
    if (self.shouldUnwindToSelectBars) {
        [self performSegueWithIdentifier:@"unwindToSelectBarsCancel" sender:self];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
    if (section == kTimeSection)
        return (self.datePickerIndexPath == nil) ? 1 : 2;
    if (section == kSpecialsSection)
        return 0;
    if (section == kContactInfoSection)
        return 2;
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kTimeSection && indexPath.row == kDatePickerRow) {
        return kDatePickerRowHeight;
    }
    return self.tableView.rowHeight;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == kTimeSection)
        return @"Time";
    if(section == kSpecialsSection)
        return @"Specials";
    if(section == kContactInfoSection)
        return @"Contact Information";

    if(section == kDescriptionSection)
        return @"Description";
    return @"";
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSUInteger messageHeight;
//    if (indexPath.section == kDescriptionSection) {
//        messageHeight = 20+[self getMessageHeight:self.currentBar.description];
//    }
//    if (indexPath.section == kContactInfoSection) {
//        messageHeight = 20+[self getMessageHeight:self.currentBar.address];
//    }
//    if (indexPath.section == kSpecialsSection) {
//        NSString *specials = [self.currentBar.specials objectForKey:self.currentDateId];
//        if ([specials length] == 0)
//            messageHeight = 0;
//        else
//            messageHeight = 20+[self getMessageHeight:[self.currentBar.specials objectForKey:self.currentDateId]];
//    }
//    if (messageHeight < 45)
//        return 45;
//    else
//        return messageHeight;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSString *cellId = nil;
    
    if (indexPath.section == kTimeSection) {
        if (indexPath.row == kTimeRow) {
            cellId = kTimeCell;
        }
        if (indexPath.row == kDatePickerRow) {
            cellId = kDatePickerCell;
        }
    } else {
        cellId = kBarInfoCell;
    }
    cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];


//    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    cell.textLabel.numberOfLines = 0;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // date picker
    if (indexPath.section == kTimeSection) {
        if (indexPath.row == kTimeRow) {
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.currentTime];
        }
        if (indexPath.row == kDatePickerRow) {
            UIDatePicker *datePicker = (UIDatePicker *)[cell viewWithTag:1];
            datePicker.date = self.currentTime;
        }
    }
    if (indexPath.section == kSpecialsSection) {
        cell.textLabel.text = [self.currentBar.specials objectForKey:self.currentDateId];
    }
    if (indexPath.section == kContactInfoSection) {
        if (indexPath.row == kAddressRow) {
            cell.textLabel.text = self.currentBar.address;
        }
        if (indexPath.row == kWebsiteRow) {
            cell.textLabel.text = self.currentBar.website;
        }
    }
    if (indexPath.section == kDescriptionSection) {
        cell.textLabel.text = self.currentBar.description;
    }
    
    return cell;
}

- (void)toggleDatePickerCellAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    if (self.datePickerIndexPath == nil) {
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];

        [self.tableView insertRowsAtIndexPaths:@[self.datePickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        // save time
        UITableViewCell *datePickerCell = [self.tableView cellForRowAtIndexPath:self.datePickerIndexPath];
        UIDatePicker *datePicker = (UIDatePicker *)[datePickerCell viewWithTag:1];
        self.currentTime = datePicker.date;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView deleteRowsAtIndexPaths:@[self.datePickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerIndexPath = nil;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView endUpdates];
}

- (IBAction)dateChanged:(id)sender
{
    NSIndexPath *timeCellIndexPath = [NSIndexPath indexPathForRow:kTimeRow inSection:kTimeSection];
    UITableViewCell *timeCell = [self.tableView cellForRowAtIndexPath:timeCellIndexPath];
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    timeCell.detailTextLabel.text = [self.dateFormatter stringFromDate:datePicker.date];
    self.currentTime = datePicker.date;
}

#pragma mark - Table view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kTimeSection && indexPath.row == kTimeRow) {
        [self toggleDatePickerCellAtIndexPath:indexPath];
    }
}
@end
