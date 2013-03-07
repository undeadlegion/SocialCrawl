//
//  EventSegmentsController.m
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "EventSegmentsController.h"
#import "BarsForEventViewController.h"
#import "InfoForEventViewController.h"
#import "MapForEventViewController.h"
#import "Event.h"
#import "Constants.h"

@interface EventSegmentsController ()
@property (nonatomic, strong, readwrite) UINavigationController *navigationController;
@property (nonatomic, strong, readwrite) NSArray *viewControllers;
@end

@implementation EventSegmentsController

BOOL isResettingIndex;

- (id)initWithNavigationController:(UINavigationController *)aNavigationController
                   viewControllers:(NSArray *)theViewControllers{
    
    if((self = [super init])){
        _navigationController = aNavigationController;
        _viewControllers = theViewControllers;
    }
    return self;
}

- (id)initWithNavigationController:(UINavigationController *)theNavigationController storyboard:(UIStoryboard *)theStoryboard{
    if((self = [super init])){
        _navigationController = theNavigationController;
        _storyboard = theStoryboard;
        [self initSegmentViewControllers];
        [self initViewToggle];
    }
    return self;
}

- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)segmentedControl{
    //don't push view if just setting the index
    if(isResettingIndex){
        isResettingIndex = NO;
        return;
    }
        
    NSUInteger index = segmentedControl.selectedSegmentIndex;
    UIViewController *incomingViewController = [self.viewControllers objectAtIndex:index];
    incomingViewController.navigationItem.titleView = segmentedControl;
    incomingViewController.navigationItem.prompt = @"View Event Details";
    
    ((InfoForEventViewController *)incomingViewController).currentEvent = self.currentEvent;
    
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController pushViewController:incomingViewController animated:NO];

}

- (void)pushFirstViewController{
    //setting the index sometimes triggers the target action
    isResettingIndex = YES;
    self.viewToggle.selectedSegmentIndex = 0;

    BarsForEventViewController *firstViewController = (BarsForEventViewController *)[self.viewControllers objectAtIndex:self.viewToggle.selectedSegmentIndex];
    firstViewController.currentEvent = self.currentEvent;
    firstViewController.navigationItem.prompt = @"View Event Details";
    firstViewController.navigationItem.titleView = self.viewToggle;
    [self.navigationController pushViewController:firstViewController animated:YES];

    //target action only sometimes goes off - make sure to reset flag
    if(isResettingIndex)
        isResettingIndex = NO;
}

- (void)initViewToggle{
    
    //change to the titles of the views
    self.viewToggle = [[UISegmentedControl alloc]
                  initWithItems:[NSArray arrayWithObjects:@"Itenerary",
                                 @"Info", @"Map", nil]];
    
    self.viewToggle.segmentedControlStyle = UISegmentedControlStyleBar;
    self.viewToggle.frame = CGRectMake(0, 0, 400, kCustomButtonHeight);
    self.viewToggle.selectedSegmentIndex = 0;
    [self.viewToggle addTarget:self action:@selector(indexDidChangeForSegmentedControl:)
         forControlEvents:UIControlEventValueChanged];
}

- (void)initSegmentViewControllers{
    BarsForEventViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BarsForEventViewController"];
    InfoForEventViewController *infoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoForEventViewController"];
    MapForEventViewController *mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapForEventViewController"];
    
    self.viewControllers = [[NSArray alloc] initWithObjects:detailViewController,infoViewController, mapViewController,nil];
    

}

@end
