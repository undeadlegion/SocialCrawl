//
//  AddDrinkViewController.h
//  SocialCrawl
//
//  Created by James Lubo on 3/9/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDrinkViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *shotsButton;
@property (weak, nonatomic) IBOutlet UIButton *beerButton;
@property (weak, nonatomic) IBOutlet UIButton *wineButton;
@property (assign, nonatomic) NSUInteger selectedButtonNumber;

@end
