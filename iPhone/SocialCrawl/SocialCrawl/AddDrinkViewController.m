//
//  AddDrinkViewController.m
//  SocialCrawl
//
//  Created by James Lubo on 3/9/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "AddDrinkViewController.h"

@interface AddDrinkViewController ()

@end

@implementation AddDrinkViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIButton *button = sender;
    if ([button.titleLabel.text isEqualToString:@"Beer"]) {
        self.selectedButtonNumber = kBeerSection;
    }
    if ([button.titleLabel.text isEqualToString:@"Shots"]) {
        self.selectedButtonNumber = kShotSection;
    }
    if ([button.titleLabel.text isEqualToString:@"Wine"]) {
        self.selectedButtonNumber = kWineSection;
    }
}

@end
