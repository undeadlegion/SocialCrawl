//
//  Bar.h
//  SocialCrawl
//
//  Created by James Lubo on 2/13/13.
//  Copyright (c) 2013 SocialCrawl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Bar : NSObject<MKAnnotation>{
    NSString *barId;
    NSString *name;
    NSString *address;
    NSString *description;
    NSString *website;
    NSString *quickLogoPath;
    NSString *detailedLogoPath;
    UIImage *detailedlogo;
    UIImage *quicklogo;
    NSMutableDictionary *specials;
    double longitude;
    double latitude;
}

@property (nonatomic, copy) NSString *barId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *website;
@property (nonatomic, copy) NSString *quickLogoPath;
@property (nonatomic, copy) NSString *detailedLogoPath;
@property (nonatomic, strong) UIImage *quickLogo;
@property (nonatomic, strong) UIImage *detailedLogo;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSMutableDictionary *specials;
@property (nonatomic) double longitude;
@property (nonatomic) double latitude;
@end
