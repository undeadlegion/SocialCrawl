//
//  AddEventViewController.m
//  SocialCrawl
//
//  Created by James Lubo on 3/7/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "AddEventViewController.h"

@interface AddEventViewController ()

@end

@implementation AddEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender
{
    [self.delegate addEventViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{
    [self.delegate addEventViewControllerDidSave:self];
}
@end
