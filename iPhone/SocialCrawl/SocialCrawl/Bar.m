//
//  Bar.m
//  CampusCrawler
//
//  Created by James Lubowich on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Bar.h"


@implementation Bar
@synthesize barId, name, address, description, website, detailedLogoPath, quickLogoPath;
@synthesize detailedLogo, quickLogo;
@synthesize coordinate, longitude, latitude;
@synthesize specials;

/*
- (id)initBarWithName:(NSString *)aName barId:(NSString *)aBarId logo:(UIImage *)aLogo{
    if((self = [super init])){
        self.name = aName;
        self.barId = aBarId;
        self.logo = aLogo;
    }
    return self;
}
-(CLLocationCoordinate2D) addressLocation {
    NSString *urlString=[NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv",[[address stringByAppendingString:@" Champaign IL"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]];
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:NULL];;
    NSArray *listItems = [locationString componentsSeparatedByString:@","];
    double latitude=0.0;
    double longitude=0.0;
    if([listItems count] >=4  && [ [listItems objectAtIndex:0] isEqualToString:@"200"])
    {
        latitude = [ [ listItems objectAtIndex:2] doubleValue];
        longitude = [ [listItems objectAtIndex:3] doubleValue];
    }
    else
    {
        NSLog(@"Error"); 
    }
    CLLocationCoordinate2D location;
    location.latitude=latitude;
    location.longitude=longitude;
    return location;
}
*/

- (id)init{
    if((self = [super init])){
        specials = [[NSMutableDictionary alloc] initWithCapacity:9];
    }
    return self;
}
- (CLLocationCoordinate2D)coordinate{
    CLLocationCoordinate2D coord;
    coord.longitude = longitude;
    coord.latitude = latitude;
    return coord;
}

- (NSString *)title{
    return name;
}

- (NSString *)subtitle{
    return description;    
}


@end
