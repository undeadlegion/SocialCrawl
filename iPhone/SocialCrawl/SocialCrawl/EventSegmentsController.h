//
//  EventSegmentsController.h
//  CampusCrawler
//
//  Created by James Lubowich on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
