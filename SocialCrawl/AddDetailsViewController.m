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

@interface AddDetailsViewController ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation AddDetailsViewController

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
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
    [self.dateFormatter setDateFormat:@"MM/dd/yy"];
    [self.dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    self.dateLabel.text = [self.dateFormatter stringFromDate:self.createdEvent.date];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"View will appear %@", self.createdEvent.date);
    NSLog(@"Formatted: %@", [self.dateFormatter stringFromDate:self.createdEvent.date]);
    self.dateLabel.text = [self.dateFormatter stringFromDate:self.createdEvent.date];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"View did appear");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SelectDate"]) {
        SelectDateViewController *viewController = [segue destinationViewController];
        viewController.createdEvent = self.createdEvent;
    }
    //    SocialCrawlViewController * viewController = [segue destinationViewController];
}


@end
