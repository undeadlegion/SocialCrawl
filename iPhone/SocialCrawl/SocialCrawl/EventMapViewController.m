//
//  EventMapViewController.m
//  CampusCrawler
//
//  Created by James Lubowich on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventMapViewController.h"
#import "Event.h"
#import "Bar.h"
#import "BarForEvent.h"
#import "SocialCrawlAppDelegate.h"
#import "BarInfoViewController.h"

@implementation EventMapViewController
@synthesize mapView, barsDictionary;
@synthesize currentEvent, serverURL, viewToggle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
    
    [mapView setRegion:region animated:NO];
    [mapView regionThatFits:region];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    self.barsDictionary = nil;
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    barAnnotations = [[NSMutableArray alloc] init];
    //add all annotations
    for (BarForEvent *barForEvent in currentEvent.barsForEvent) {
        Bar *bar = [barsDictionary objectForKey:barForEvent.barId];
        [barAnnotations addObject:bar];
        [mapView addAnnotation:bar];
    }
    
    [self goToLocation];
}

- (void)viewWillDisappear:(BOOL)animated{
    //remove all annotations
    for (Bar *bar in barAnnotations) {
        [mapView removeAnnotation:bar];
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
    detailViewController.currentDateId = currentEvent.dateId;

    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
