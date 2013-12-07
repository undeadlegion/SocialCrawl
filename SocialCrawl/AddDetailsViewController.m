//
//  AddDetailsViewController.m
//  SocialCrawl
//
//  Created by James Lubo on 8/26/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "AddDetailsViewController.h"
#import "SocialCrawlViewController.h"
#import "SelectDateViewController.h"
#import "BarForEvent.h"
#import "SocialCrawlAppDelegate.h"

@interface AddDetailsViewController ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, assign) BOOL pickerHidden;
@end

@implementation AddDetailsViewController

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"MM/dd/yy"];
        [_dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    }
    return _dateFormatter;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.dateCell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.createdEvent.date];
    self.pickerHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ([self.createdEvent.privacyType isEqualToString:kPrivacyTypePrivate]) {
        self.privacyToggle.on = YES;
    } else {
        self.privacyToggle.on = NO;
    }
    self.textView.text = self.createdEvent.eventDescription;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.privacyToggle isOn]) {
        self.createdEvent.privacyType = kPrivacyTypePrivate;
    } else {
        self.createdEvent.privacyType = kPrivacyTypePublic;
    }
    self.createdEvent.eventDescription = self.textView.text;
    [self.textView resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.createdEvent.eventDescription = self.textView.text;
    
    if ([segue.identifier isEqualToString:@"SelectDate"]) {
        self.createdEvent.eventDescription = self.textView.text;
        SelectDateViewController *viewController = [segue destinationViewController];
        viewController.createdEvent = self.createdEvent;
    } else if ([segue.identifier isEqualToString:@"SaveCreatedEvent"]) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        unsigned dateFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        unsigned timeFlags = NSHourCalendarUnit | NSMinuteCalendarUnit;
        NSDateComponents *dateComps, *timeComps;

        // set event start time
        BarForEvent *firstBarForEvent = [self.createdEvent.barsForEvent firstObject];
        if (firstBarForEvent) {
            dateComps = [calendar components:dateFlags fromDate:self.createdEvent.date];
            timeComps = [calendar components:timeFlags fromDate:firstBarForEvent.time];
            dateComps.hour = timeComps.hour;
            dateComps.minute = timeComps.minute;
            dateComps.second = 0;
            self.createdEvent.date = [calendar dateFromComponents:dateComps];
        }
        
        // reflect new event date in selected bars
        for (BarForEvent *barForEvent in self.createdEvent.barsForEvent) {
            dateComps = [calendar components:dateFlags fromDate:self.createdEvent.date];
            timeComps = [calendar components:timeFlags fromDate:barForEvent.time];
            dateComps.hour = timeComps.hour;
            dateComps.minute = timeComps.minute;
            dateComps.second = 0;
            barForEvent.time = [calendar dateFromComponents:dateComps];
        }

        // set creator id
        SocialCrawlAppDelegate *appDelegate = (SocialCrawlAppDelegate *)[[UIApplication sharedApplication] delegate];
        self.createdEvent.creatorId = appDelegate.fbId;
        
        // create event on server
        SocialCrawlAppDelegate *delegate = (SocialCrawlAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate createEvent:self.createdEvent];
    }
}

- (void)getPublishPermissions
{
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
                                                 [self performSegueWithIdentifier:@"SaveCreatedEvent" sender:self];
                                             }
                                         }];
    } else {
        if (![FBSession.activeSession.permissions containsObject:@"create_event"]) {
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
                                                          [self performSegueWithIdentifier:@"SaveCreatedEvent"sender:self];         
                                                      }
                                                  }];
        } else {
            [self performSegueWithIdentifier:@"SaveCreatedEvent"sender:self];
        }
    }
}
- (IBAction)dateChanged:(id)sender
{
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    self.createdEvent.date = datePicker.date;
    self.dateCell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.createdEvent.date];
}

- (IBAction)doneButtonPressed:(id)sender
{
    [self getPublishPermissions];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kDateSection && indexPath.row == kDatePickerRow) {
        return kDatePickerRowHeight;
    }
    if (indexPath.section == kEventDescriptionSection) {
        return self.descriptionCell.frame.size.height;
    }
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kDateSection && indexPath.row == kDateRow) {
        self.pickerHidden = !self.pickerHidden;
        NSIndexPath *pickerIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
        if (self.pickerHidden) {
            [tableView deleteRowsAtIndexPaths:@[pickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [tableView insertRowsAtIndexPaths:@[pickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView scrollToRowAtIndexPath:pickerIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kDateSection) {
        return (self.pickerHidden) ? 1 : 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kEventDescriptionSection) {
        return self.descriptionCell;
    }
    if (indexPath.section == kPrivacySection) {
        return self.privacyCell;
    }
    if (indexPath.section == kDateSection) {
        if (indexPath.row == kDateRow) {
            return self.dateCell;
        } else {
            UIDatePicker *datePicker = (UIDatePicker *)[self.datePickerCell viewWithTag:1];
            datePicker.date = self.createdEvent.date;
            return self.datePickerCell;
        }
    }
    return nil;
}
@end
