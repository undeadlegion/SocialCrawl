//
//  SelectDateViewController.m
//  SocialCrawl
//
//  Created by James Lubo on 9/28/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "SelectDateViewController.h"

@interface SelectDateViewController ()

@end

@implementation SelectDateViewController

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
    self.datePicker.minimumDate = [NSDate date];
    self.datePicker.date = self.createdEvent.date;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.createdEvent.date = self.datePicker.date;
    [super viewWillDisappear:animated];
}
@end
