//
//  BarDetailViewController.h
//  CampusCrawler
//
//  Created by James Lubowich on 2/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Bar;
@interface BarDetailViewController : UITableViewController{
    Bar *currentBar;
    NSString *currentDateId;
}
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIImageView *headerImage;
@property (nonatomic, strong) IBOutlet UILabel *headerLabel;
@property (nonatomic, strong) Bar *currentBar;
@property (nonatomic, copy) NSString *currentDateId;

- (CGFloat)getMessageHeight:(NSString *)text;

@end
