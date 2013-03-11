//
//  SocialCrawlViewController.m
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "SocialCrawlViewController.h"
#import "EventSegmentsController.h"
#import "Event.h"
#import "EventsFetcher.h"

@interface SocialCrawlViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation SocialCrawlViewController

# pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // register notification for when events finish loading
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventsListLoaded:) name:@"events" object:nil];
    [self.tableView reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"events" object:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddEvent"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddEventViewController *addEventViewController = [[navigationController viewControllers] objectAtIndex:0];
        addEventViewController.delegate = self;
    }
}
#pragma mark - Date Methods

- (void)sortEvents{
    self.pastEvents = [[NSMutableArray alloc] init];
    self.currentEvents = [[NSMutableArray alloc] init];
    
    for (Event *event in self.eventsList[@"0"]) {
        if([event isPast]){
            [self.pastEvents insertObject:event atIndex:0];
        }
        else{
            [self.currentEvents addObject:event];
        }
    }
}

- (NSString *)fuzzyDateFromDate:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit| NSHourCalendarUnit;
    NSDateComponents *dateComps = [calendar components:unitFlags fromDate:[NSDate date] toDate:date options:0];
    int year = [dateComps year];
    int months = [dateComps month];
    int days = [dateComps day];
    
    if(year == 0 && months >= 0 && days >= 0){
        if(months == 0){
            if(days == 0)
                return @"Today";
            if(days == 1)
                return @"Tomorrow";
            if(days == 2)
                return @"Two Days";
            if(days == 3)
                return @"Three Days";
            if(days < 5)
                return @"A Few Days";
            if(days < 10)
                return @"A Week";
            if(days < 17)
                return @"Two Weeks";
            return @"A Few Weeks";
        }
        if(months == 1)
            return @"A Month";
        if(months == 2)
            return @"Two Months";
        if(months == 3)
            return @"A Couple Months";
        if(months < 6)
            return @"A Few Months";
    }
    return [self.dateFormatter stringFromDate:date];
}

# pragma mark - Lazy Instantiation
- (NSMutableArray *)currentEvents {
    if (!_currentEvents) _currentEvents = [[NSMutableArray alloc] init];
    return _currentEvents;
}
- (NSMutableArray *)pastEvents {
    if (!_pastEvents) _pastEvents = [[NSMutableArray alloc] init];
    return _pastEvents;
}
- (EventSegmentsController *)eventSegmentsController {
    if (!_eventSegmentsController) _eventSegmentsController = [[EventSegmentsController alloc] initWithNavigationController:self.navigationController storyboard:self.storyboard];
    return _eventSegmentsController;
}
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"MM/dd/yy"];
    }
    return _dateFormatter;
}
- (NSDictionary *)eventsList {
    if (!_eventsList) {
        _eventsList = [[NSDictionary alloc] init];
    }
    return _eventsList;
}

- (void)eventsListLoaded:(NSNotification *)notif {
    self.eventsList = notif.userInfo;
    [self sortEvents];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == kCurrentSection) 
        return [self.currentEvents count];
    if(section == kPastSection)
        return [self.pastEvents count];
    NSLog(@"Error returning 0 rows");
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == kCurrentSection)
        return @"Current Events";
    if(section == kPastSection)
        return @"Past Events";
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BarCrawlCell"];

    Event *cellEvent;
    if(indexPath.section == kCurrentSection)
        cellEvent = self.currentEvents[indexPath.row];
    if(indexPath.section == kPastSection)
        cellEvent = self.pastEvents[indexPath.row];
    
    cell.textLabel.text = cellEvent.title;
    cell.detailTextLabel.text = [self fuzzyDateFromDate:cellEvent.date];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    Event *selectedEvent;
    if(indexPath.section == kCurrentSection)
        selectedEvent = [self.currentEvents objectAtIndex:indexPath.row];
    if(indexPath.section == kPastSection)
        selectedEvent = [self.pastEvents objectAtIndex:indexPath.row];
    self.eventSegmentsController.currentEvent = selectedEvent;
    self.eventSegmentsController.barsDictionary = self.barsDictionary;
    [self.eventSegmentsController pushFirstViewController];
}

#pragma mark - Add event view controller delegate

- (void)addEventViewControllerDidCancel:(AddEventViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addEventViewControllerDidSave:(AddEventViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)unwindToSocialCrawlViewController:(UIStoryboardSegue *)segue
{
    NSLog(@"Segue back to Socialcrawl!");
}
@end
