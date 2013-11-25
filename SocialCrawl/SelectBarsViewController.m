//
//  SelectBarsViewController.m
//  SocialCrawl
//
//  Created by James Lubo on 8/26/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "SelectBarsViewController.h"
#import "AddDetailsViewController.h"
#import "SocialCrawlAppDelegate.h"
#import "Bar.h"
#import "BarForEvent.h"
#import "BarInfoViewController.h"

@interface SelectBarsViewController ()
@property (nonatomic, strong) NSMutableArray *selectedBars;
@property (nonatomic, strong) NSMutableArray *otherBars;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic, weak) NSDictionary *barsDictionary;

@end

@implementation SelectBarsViewController

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
    
    [self populateOtherBars];
    [self sortOtherBars];
    
    self.createdEvent.barsForEvent = self.selectedBars;
    [self.tableView setEditing:YES animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(barsFinishedLoading:) name:@"barsforid" object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"h:mm a"];
        [_dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    }
    return _dateFormatter;
}

- (NSDictionary *)barsDictionary
{
    if (!_barsDictionary) {
        SocialCrawlAppDelegate *delegate = (SocialCrawlAppDelegate *)[UIApplication sharedApplication].delegate;
        _barsDictionary = delegate.barsDictionary;
    }
    return _barsDictionary;
}

- (NSMutableArray *)selectedBars
{
    if (!_selectedBars) {
        _selectedBars = [[NSMutableArray alloc] init];
    }
    return _selectedBars;
}

- (NSMutableArray *)otherBars
{
    if (!_otherBars) {
        _otherBars = [[NSMutableArray alloc] init];
    }
    return _otherBars;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kSelectedSection) {
        return [self.selectedBars count];
    }
    if (section == kOtherSection) {
        return [self.otherBars count];
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == kSelectedSection) {
        return @"Selcted Bars";
    }
    if (section == kOtherSection) {
        return @"Other Bars";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BarForEventCell" forIndexPath:indexPath];
    BarForEvent *barForEvent;
    
    if (indexPath.section == kSelectedSection) {
        barForEvent = [self.selectedBars objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [self.dateFormatter stringFromDate:barForEvent.time];
    }
    if (indexPath.section == kOtherSection) {
        barForEvent = [self.otherBars objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = @"";
    }
    
    Bar *bar = [self.barsDictionary objectForKey:barForEvent.barId];
    
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = bar.name;
    
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kSelectedSection) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleInsert;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == kSelectedSection) {
//        return YES;
//    }
//    return NO;
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == kSelectedSection) {
//        return YES;
//    }
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if (fromIndexPath.section == kSelectedSection && toIndexPath.section == kSelectedSection) {
        BarForEvent *fromBar = [self.selectedBars objectAtIndex:fromIndexPath.row];
        [self.selectedBars removeObjectAtIndex:fromIndexPath.row];
        [self.selectedBars insertObject:fromBar atIndex:toIndexPath.row];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kSelectedSection) {
        return YES;
    }
    return NO;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    [self performSegueWithIdentifier:@"BarInfo" sender:cell];
//
//    if (indexPath.section == kSelectedSection) {
//    }
//    if (indexPath.section == kOtherSection) {
//
//    }
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == kSelectedSection) {
            [self.tableView beginUpdates];
            BarForEvent *selectedBar = [self.selectedBars objectAtIndex:indexPath.row];
            selectedBar.time = nil;
            
            // delete from selected bars
            [self.selectedBars removeObject:selectedBar];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            // insert into other bars
            int otherIndex = [self.otherBars indexOfObject:selectedBar
                                             inSortedRange:NSMakeRange(0, [self.otherBars count])
                                                   options:NSBinarySearchingInsertionIndex
                                           usingComparator:^(BarForEvent *bar1, BarForEvent *bar2){
                                               NSString *barName1 = [self.barsDictionary[bar1.barId] name];
                                               NSString *barName2 = [self.barsDictionary[bar2.barId] name];
                                               return[barName1 compare:barName2];
                                           }];
            NSIndexPath *otherSection = [NSIndexPath indexPathForRow:otherIndex inSection:kOtherSection];
            [self.otherBars insertObject:selectedBar atIndex:otherIndex];
            [tableView insertRowsAtIndexPaths:@[otherSection] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        if (indexPath.section == kOtherSection) {
            BarForEvent *selectedBar = [self.otherBars objectAtIndex:indexPath.row];
            [self setDefaultTimeForEventBar:selectedBar];
            [self addToSelectedBarsFromIndexPath:indexPath];
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"BarInfo"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        BarInfoViewController *barInfoViewController = [[navigationController viewControllers] objectAtIndex:0];
        
        UITableViewCell *selectedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedCell];
        
        BarForEvent *eventBar;
        if(indexPath.section == kSelectedSection) {
            eventBar = [self.selectedBars objectAtIndex:indexPath.row];
        }
        if(indexPath.section == kOtherSection) {
            eventBar = [self.otherBars objectAtIndex:indexPath.row];
        }
        
        [self setDefaultTimeForEventBar:eventBar];
        barInfoViewController.shouldUnwindToSelectBars = YES;
        barInfoViewController.currentBar = [self.barsDictionary objectForKey:eventBar.barId];
        barInfoViewController.currentDateId = self.createdEvent.dateId;
        barInfoViewController.eventBar = eventBar;
    }
    if ([segue.identifier isEqualToString:@"AddDetails"]) {
        AddDetailsViewController *viewController = [segue destinationViewController];
        viewController.createdEvent = self.createdEvent;
    }
}

- (IBAction)unwindToSelectBarsSave:(UIStoryboardSegue *)segue
{
    BarInfoViewController *barInfoViewController = segue.sourceViewController;
    // if not a previously selected bar
    if (![self.selectedBars containsObject:barInfoViewController.eventBar]) {
        // add to selected bars
        NSInteger otherRowIndex = [self.otherBars indexOfObject:barInfoViewController.eventBar];
        NSIndexPath *otherBarsIndexPath = [NSIndexPath indexPathForRow:otherRowIndex inSection:kOtherSection];
        [self addToSelectedBarsFromIndexPath:otherBarsIndexPath];

    // previously selected so just reload the updated time
    } else {
        [self.tableView reloadData];
    }
}
- (IBAction)unwindToSelectBarsCancel:(UIStoryboardSegue *)segue
{
}

#pragma mark - Instance Methods
- (void)addToSelectedBarsFromIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    BarForEvent *bar = [self.otherBars objectAtIndex:indexPath.row];
    NSInteger insertRowIndex = [self.selectedBars indexOfObject:bar
                                                  inSortedRange:NSMakeRange(0, [self.selectedBars count])
                                                        options:NSBinarySearchingInsertionIndex
                                                usingComparator:^(BarForEvent *bar1, BarForEvent *bar2) {
                                                    return [bar1.time compare:bar2.time];
                                                }];
    NSIndexPath *selectedBarsIndexPath = [NSIndexPath indexPathForRow:insertRowIndex inSection:kSelectedSection];
    
    [self.otherBars removeObject:bar];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.selectedBars addObject:bar];
    [self.tableView insertRowsAtIndexPaths:@[selectedBarsIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView endUpdates];
}

- (void)setDefaultTimeForEventBar:(BarForEvent *)eventBar
{
    if (eventBar.time != nil) {
        return;
    }
    if ([self.selectedBars count] > 0) {
        eventBar.time = [[[self.selectedBars lastObject] time] dateByAddingTimeInterval:3600];
    } else {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSDateComponents *dateComps = [calendar components:unitFlags fromDate:self.createdEvent.date];
        dateComps.hour = 19;
        dateComps.minute = 0;
        dateComps.second = 0;
        eventBar.time = [calendar dateFromComponents:dateComps];
    }
}

- (void)barsFinishedLoading:(NSNotification *)notification
{
    NSLog(@"BarsForEvent: Bars loaded");
    self.barsDictionary = notification.userInfo;
    
    [self populateOtherBars];
    [self sortOtherBars];
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    [self.tableView reloadData];
}

- (void)populateOtherBars
{
    // populate list of bars
    for (Bar *bar in [self.barsDictionary allValues]) {
        BarForEvent *barForEvent = [[BarForEvent alloc] init];
        barForEvent.barId = bar.barId;
        [self.otherBars addObject:barForEvent];
    }
}
- (void)sortOtherBars
{
    [self.otherBars sortUsingComparator:^(BarForEvent *bar1, BarForEvent *bar2){
        NSString *barName1 = [self.barsDictionary[bar1.barId] name];
        NSString *barName2 = [self.barsDictionary[bar2.barId] name];
        return[barName1 compare:barName2];
        
    }];
}
@end
