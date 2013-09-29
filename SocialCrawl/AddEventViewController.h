//
//  AddEventViewController.h
//  SocialCrawl
//
//  Created by James Lubo on 3/7/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AddEventViewController;

@protocol AddEventViewControllerDelegate <NSObject>
- (void)addEventViewControllerDidCancel:(AddEventViewController *)controller;
- (void)addEventViewControllerDidSave:(AddEventViewController * )controller;
@end

@interface AddEventViewController : UIViewController
@property (nonatomic, weak) id <AddEventViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)addFromFacebook:(id)sender;

@end
