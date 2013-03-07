//
//  MapForEventViewController.h
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import "MapForEventViewController.h"
#import "Event.h"
#import "Bar.h"
#import "BarForEvent.h"
#import "SocialCrawlAppDelegate.h"
#import "BarInfoViewController.h"

@implementation MapForEventViewController

- (NSDictionary *)barsDictionary {
    if (!_barsDictionary) {
        SocialCrawlAppDelegate *delegate = [UIApplication sharedApplication].delegate;
        _barsDictionary = delegate.barsDictionary;
    }
    return _barsDictionary;
}

#pragma mark - View lifecycle

- (void)goToLocation{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.007;
    span.longitudeDelta=0.007;
    
    //fourth and green
    CLLocationCoordinate2D location;
    location.latitude = 40.1102662;
    location.longitude = -88.2335352;
    region.span=span;
    region.center=location;
    
    [self.mapView setRegion:region animated:NO];
    [self.mapView regionThatFits:region];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(barsFinishedLoading:) name:@"bars" object:nil];
}

- (void)barsFinishedLoading:(NSNotification *)notif
{
    self.barsDictionary = notif.userInfo;
    // TODO: reload data
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bars" object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    barAnnotations = [[NSMutableArray alloc] init];
    //add all annotations
    for (BarForEvent *barForEvent in self.currentEvent.barsForEvent) {
        Bar *bar = [self.barsDictionary objectForKey:barForEvent.barId];
        [barAnnotations addObject:bar];
        [self.mapView addAnnotation:bar];
    }
    
    [self goToLocation];
}

- (void)viewWillDisappear:(BOOL)animated{
    //remove all annotations
    for (Bar *bar in barAnnotations) {
        [self.mapView removeAnnotation:bar];
    }
}

#pragma mark - Map Kit Delegate

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        NSLog(@"Is Current Location");
        return nil;
    }    
    
    if ([annotation isKindOfClass:[Bar class]])
        {
        // try to dequeue an existing pin view first
        static NSString* BarAnnotationIdentifier = @"barAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:BarAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                                   initWithAnnotation:annotation reuseIdentifier:BarAnnotationIdentifier];
            customPinView.pinColor = MKPinAnnotationColorGreen;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            // add a detail disclosure button to the callout which will open a new view controller page
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self
                            action:@selector(showDetails:)
                  forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

- (void)showDetails:(id)sender{
    UIButton *button = sender;
    UIView *calloutAccessoryView = button.superview;
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)calloutAccessoryView.superview;
    Bar *selectedBar = pinView.annotation;
    
    BarInfoViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BarInfoViewController"];
    detailViewController.currentBar = selectedBar;
    detailViewController.currentDateId = self.currentEvent.dateId;

    [self.navigationController pushViewController:detailViewController animated:YES];
}

//    MKPlacemark *placemark = [MKPlacemark alloc] initWithCoordinate:<#(CLLocationCoordinate2D)#> addressDictionary:<#(NSDictionary *)#>

//    if(addAnnotation != nil) 
//    {
//        [mapView removeAnnotation:addAnnotation];
//        [addAnnotation release];
//        addAnnotation=nil;
//    }
//
// note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
//  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
//
@end
