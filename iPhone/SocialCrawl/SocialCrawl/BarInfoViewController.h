//
//  BarInfoViewController.h
//  CampusCrawler
//
//  Created by James Lubowich on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Bar;
@interface BarInfoViewController : UITableViewController

@property (nonatomic, strong) Bar *currentBar;
@property (nonatomic, copy) NSString *currentDateId;
@property (weak, nonatomic) IBOutlet UIImageView *headerViewImage;
@property (weak, nonatomic) IBOutlet UILabel *headerViewLabel;


- (CGFloat)getMessageHeight:(NSString *)text;

@end
