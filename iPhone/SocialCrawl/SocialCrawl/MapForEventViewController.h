//
//  MapForEventViewController.h
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class Event;
@interface MapForEventViewController : UIViewController<MKMapViewDelegate> {
    MKPinAnnotationView *annotationView;
    NSMutableArray *barAnnotations;
}

@property (nonatomic, strong) Event *currentEvent;
@property (nonatomic, copy) NSURL *serverURL;
@property (nonatomic, strong) UISegmentedControl *viewToggle;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) NSDictionary *barsDictionary;

- (void)showDetails:(id)sender;
@end
