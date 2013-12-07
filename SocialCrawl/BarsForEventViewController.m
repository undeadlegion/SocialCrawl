//
//  EventDetailViewController.m
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "BarsForEventViewController.h"
#import "Event.h"
#import "BarForEvent.h"
#import "BarInfoViewController.h"
#import "BarsForEventFetcher.h"
#import "Bar.h"
#import "SocialCrawlAppDelegate.h"
#import "Reachability.h"
#import "MBProgressHUD.h"

@interface BarsForEventViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (assign, nonatomic) BOOL shouldReloadBars;
@end

@implementation BarsForEventViewController


- (NSDictionary *)barsDictionary {
    if (!_barsDictionary) {
        SocialCrawlAppDelegate *delegate = (SocialCrawlAppDelegate *)[UIApplication sharedApplication].delegate;
        _barsDictionary = delegate.barsDictionary;
    }
    return _barsDictionary;
}
- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"h:mm a"];
        [_dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    }
    return _dateFormatter;
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(barsForEventFinishedLoading:) name:@"barsforevent" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(barsFinishedLoading:) name:@"barsforid" object:nil];

    self.shouldReloadBars = YES;
    self.serverURL = [[NSURL alloc] initWithString:serverString];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [TestFlight passCheckpoint:@"Viewing Crawl"];
    // tutorial event
    if ([self.currentEvent.title isEqualToString:@"Example SocialCrawl"]) {
        self.currentBars = [self.currentEvent.barsForEvent mutableCopy];
        [self.tableView reloadData];
        return;
    }
    // reload bars for event
    if (self.shouldReloadBars) {
        SocialCrawlAppDelegate *delegate = (SocialCrawlAppDelegate *)[UIApplication sharedApplication].delegate;
        NSOperation *loadOperation = [delegate loadFromServer:@{@"type":@"barsforevent", @"id":self.currentEvent.eventId}];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.name = @"Event Loader";
        [queue addOperation:loadOperation];
        
        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        progressHUD.labelText = @"Loading";
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.shouldReloadBars = YES;
    [super viewWillDisappear:animated];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"barsforevent" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"barsforid" object:nil];
}

- (void)barsForEventFinishedLoading:(NSNotification *)notification {
    NSLog(@"BarsForEvent: BarsForEvent loaded");
    if (self.barsDictionary) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    self.currentEvent.barsForEvent = notification.userInfo[@"0"];
    [self scheduleNotifications];
    [self sortBarsForEvent];
    [self updateBarSpecials];
    [self.tableView reloadData];
}

- (void)barsFinishedLoading:(NSNotification *)notification {
    NSLog(@"BarsForEvent: Bars loaded");
    self.barsDictionary = notification.userInfo;

    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self.tableView reloadData];
}

- (IBAction)unwindToBarsForEventSave:(UIStoryboardSegue *)segue
{
    NSLog(@"BarsForEvent: Unwinding segue");
    self.shouldReloadBars = NO;
    BarInfoViewController *barInfoViewController = segue.sourceViewController;
    if (barInfoViewController.timeChanged && [barInfoViewController canEditEvent]) {
        [TestFlight passCheckpoint:@"Event Time Edited"];
        //send edits to server
        SocialCrawlAppDelegate *delegate = (SocialCrawlAppDelegate *)[[UIApplication sharedApplication] delegate];

        self.currentEvent.editedBar =  barInfoViewController.eventBar;
        [delegate editEvent:self.currentEvent];
        self.shouldReloadBars = YES;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BarInfo"]) {
        [TestFlight passCheckpoint:@"Bar Selected"];
        UINavigationController *navigationController = segue.destinationViewController;
        BarInfoViewController *barInfoViewController = [[navigationController viewControllers] objectAtIndex:0];
        UITableViewCell *selectedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedCell];
        
        BarForEvent *eventBar;
        if(indexPath.section == kCurrentSection)
            eventBar = [self.currentBars objectAtIndex:indexPath.row];
        if(indexPath.section == kPastSection)
            eventBar = [self.pastBars objectAtIndex:indexPath.row];
        
        barInfoViewController.shouldUnwindToSelectBars = NO;
        barInfoViewController.currentBar = [self.barsDictionary objectForKey:eventBar.barId];
        barInfoViewController.currentDateId = self.currentEvent.dateId;
        barInfoViewController.eventBar = eventBar;
    }
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == kCurrentSection)
        return [self.currentBars count];
    if(section == kPastSection)
        return [self.pastBars count];
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == kCurrentSection)
        return @"Current Bars";
    if(section == kPastSection)
        return @"Past Bars";
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BarForEventCell" forIndexPath:indexPath];
    BarForEvent *barForEvent;
    
    if(indexPath.section == kCurrentSection){
        barForEvent = [self.currentBars objectAtIndex:indexPath.row];
    }
    if(indexPath.section == kPastSection){
        barForEvent = [self.pastBars objectAtIndex:indexPath.row];
    }
    
    Bar *bar = [self.barsDictionary objectForKey:barForEvent.barId];
    
    cell.textLabel.text = bar.name;
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:barForEvent.time];
    
    //image view resizing properties
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );

    //scale the image
    CGSize size = CGSizeMake(50, 50);
    UIGraphicsBeginImageContext(size);
    [bar.quickLogo drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newThumbnail = UIGraphicsGetImageFromCurrentImageContext(); 
    UIGraphicsEndImageContext();
    if(newThumbnail == nil) 
        NSLog(@"could not scale image");
        
    cell.imageView.image = newThumbnail;

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - Instance Methods

- (void)sortBarsForEvent{
    self.pastBars = [[NSMutableArray alloc] init];
    self.currentBars = [[NSMutableArray alloc] init ];
    for (BarForEvent *bar in self.currentEvent.barsForEvent) {
        if([bar isPast]){
            [self.pastBars addObject:bar];
        }
        else{
            [self.currentBars addObject:bar];
        }
    }
}

- (void)updateBarSpecials{
//    for (BarForEvent *barForEvent in self.currentEvent.barsForEvent) {
//        Bar *bar = [self.barsDictionary objectForKey:barForEvent.barId];
//        [bar.specials setObject:barForEvent.specials forKey:self.currentEvent.dateId];
//    }
}

- (void)scheduleNotifications{
//    NSLog(@"ScheduleNotifications Called");
    NSArray *scheduledNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
//    NSLog(@"Count:%d", [self.currentEvent.barsForEvent count]);
    for (BarForEvent *barForEvent in self.currentEvent.barsForEvent){
        BOOL isScheduled = NO;
        for (UILocalNotification *notif in scheduledNotifications) {
            if([[notif.userInfo objectForKey:@"Id"] isEqualToString:self.currentEvent.eventId]){
                isScheduled = YES;
                break;
            }
        }
        //no need to schedule
        if(isScheduled)
            continue;
        if (!barForEvent.time) {
            NSLog(@"TIME IS NIL");
        }
        //get the days and hours between now and the event
        NSCalendar *calendar = [NSCalendar currentCalendar];
        unsigned unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit |NSDayCalendarUnit| NSHourCalendarUnit |NSMinuteCalendarUnit |NSSecondCalendarUnit;
        NSDateComponents *dateComps = [calendar components:unitFlags fromDate:[NSDate date] toDate:barForEvent.time options:0];
//        int years = [dateComps year];
//        int months = [dateComps month];
        int days = [dateComps day];
        int hours = [dateComps hour];
        int minutes = [dateComps minute];
        int seconds = [dateComps second];
        
//        NSLog(@"Cheking %@ in the past", ((Bar*)[self.barsDictionary objectForKey:barForEvent.barId]).name);
//        NSLog(@"Results: %d,%d,%d,%d,%d", years, months, days, hours, minutes);

        //of if in past
        //|| years != 0 || months != 0
        if(days < 0 || hours < 0)
            continue;
        
        //it's the day of
        if(days == 0 || (days == 1 && hours == 0)){
            NSLog(@"It's the day of");                  
            //schedule each of the bars
            UILocalNotification *notification;
            NSDictionary *infoDict;
            //0 minute warning
            if(minutes > 0 || seconds > 0){
                NSLog(@"Schedule 0 minute: %@", [NSDateFormatter localizedStringFromDate:barForEvent.time dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
                notification = [[UILocalNotification alloc] init];
                notification.fireDate = barForEvent.time;
                notification.timeZone = [NSTimeZone defaultTimeZone];
                notification.soundName = UILocalNotificationDefaultSoundName;
                NSString *message = [NSString stringWithFormat:@"Go to %@ NOW!", ((Bar*)[self.barsDictionary objectForKey:barForEvent.barId]).name];
                notification.alertBody = message;
                notification.alertAction = @"";
                infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Bar", @"Type", self.currentEvent.eventId, @"Id", message, @"Message", barForEvent.time, @"Time", nil];
                notification.userInfo = infoDict;
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            }
            //10 minute warning
            if(minutes > 10){
                NSLog(@"Schedule 10 minute: %@", [NSDateFormatter localizedStringFromDate:[barForEvent.time dateByAddingTimeInterval:-600] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
                notification = [[UILocalNotification alloc] init];
                notification.fireDate = [barForEvent.time dateByAddingTimeInterval:-600];
                notification.timeZone = [NSTimeZone defaultTimeZone];
                notification.soundName = UILocalNotificationDefaultSoundName;
                NSString *message = [NSString stringWithFormat:@"Go to %@ in 10 minutes!", ((Bar*)[self.barsDictionary objectForKey:barForEvent.barId]).name];
                notification.alertBody = notification.alertBody = message;
                notification.alertAction = @"";
                infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Bar", @"Type", self.currentEvent.eventId, @"Id",
                            message, @"Message",[barForEvent.time dateByAddingTimeInterval:-600], @"Time", nil];
                notification.userInfo = infoDict;
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            }
            //15 minute warning
            if(minutes > 15){
                NSLog(@"Schedule 15 minute: %@", [NSDateFormatter localizedStringFromDate:[barForEvent.time dateByAddingTimeInterval:-900] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]);
                notification = [[UILocalNotification alloc] init];
                notification.fireDate = [barForEvent.time dateByAddingTimeInterval:-900];
                notification.timeZone = [NSTimeZone defaultTimeZone];
                notification.soundName = UILocalNotificationDefaultSoundName;
                NSString *message = [NSString stringWithFormat:@"Go to %@ in 15 minutes!", ((Bar*)[self.barsDictionary objectForKey:barForEvent.barId]).name];
                notification.alertBody = notification.alertBody = message;
                notification.alertAction = @"";
                infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Bar", @"Type", self.currentEvent.eventId, @"Id", message, @"Message",[barForEvent.time dateByAddingTimeInterval:-900], @"Time", nil];
                notification.userInfo = infoDict;
                
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                
            }
        }
    }
    
}


@end
