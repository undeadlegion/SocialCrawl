//
//  EventSegmentsController.h
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Event;
@interface EventSegmentsController : NSObject

@property (nonatomic, strong, readonly) UINavigationController *navigationController;
@property (nonatomic, strong, readonly) NSArray *viewControllers;
@property (nonatomic, strong) NSURL *serverURL;
@property (nonatomic, strong) Event *currentEvent;
@property (nonatomic, strong) NSDictionary *barsDictionary;
@property (nonatomic, strong) UISegmentedControl *viewToggle;
@property (nonatomic, weak) UIStoryboard *storyboard;

- (id)initWithNavigationController:(UINavigationController *)navigationController
               viewControllers:(NSArray *)viewControllers;
               
- (id)initWithNavigationController:(UINavigationController *)navigationController storyboard:(UIStoryboard *)storyboard;
- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)segmentedControl;
- (void)pushFirstViewController;
- (void)initSegmentViewControllers;
- (void)initViewToggle;

@end
