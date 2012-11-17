//
//  SPTaggedAdModel.m
//  SuperPAC
//
//  Created by Nick Donaldson on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SPTaggedAdModel.h"
#import "NSDate+PrintHelpers.h"
#import "NSDictionary+Ad.h"
#import "NSDictionary+Committee.h"
#import "NSDictionary+MyTagsSort.h"

@interface SPTaggedAdModel ()

- (UIImage *)pinImageForTag:(NSString *)tag;

@end

@implementation SPTaggedAdModel

@synthesize ad = _ad;

- (id)initWithAd:(NSDictionary *)ad
{
    self = [super init];
    if (self){
        self.ad = ad;
    }
    return self;
}

- (MKAnnotationView*)annotationView
{
    NSString *lasttag = [_ad lastTag];
    
    MKAnnotationView *aView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"taggedAd"];
    aView.opaque = NO;
    aView.canShowCallout = YES;
    aView.image = [self pinImageForTag:lasttag];
    aView.centerOffset = CGPointMake(-kMapPinCenterOffsetX, -kMapPinCenterOffsetY);
    aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[self imageForTag:lasttag]];
    aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return aView;
}

- (UIImage *)pinImageForTag:(NSString *)tag {
    if([tag isEqualToString:kAdTagLove]) {
        return [UIImage imageNamed:@"pin-love"];
    } else if ([tag isEqualToString:kAdTagFail]) {
        return [UIImage imageNamed:@"pin-fail"];
    } else if ([tag isEqualToString:kAdTagFishy]) {
        return [UIImage imageNamed:@"pin-fishy"];
    } else {
        return [UIImage imageNamed:@"pin-fair"];
    }
}

- (UIImage *)imageForTag:(NSString *)tag {
    if([tag isEqualToString:kAdTagLove]) {
        return [UIImage imageNamed:@"love_icon_small"];
    } else if ([tag isEqualToString:kAdTagFail]) {
        return [UIImage imageNamed:@"fail_icon_small"];
    } else if ([tag isEqualToString:kAdTagFishy]) {
        return [UIImage imageNamed:@"fishy_icon_small"];
    } else {
        return [UIImage imageNamed:@"fair_icon_small"];
    }
}


#pragma mark - MKAnnotation protocol

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D theCoord;
    theCoord.latitude = [_ad latitude]; // *(1.0 + (arc4random()*0.01/ARC4RANDOM_MAX - 0.005));
    theCoord.longitude = [_ad longitude]; //*(1.0 + (arc4random()*0.01/ARC4RANDOM_MAX - 0.005));
    return theCoord;
}

- (NSString*)title
{
    return [_ad adTitle];
}

- (NSString*)subtitle
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];   
    [dateFormatter setDateFormat:kUpdatedAtTimestampFormat];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    NSString* tempString = [_ad adUpdatedAt];
    NSString* date = [[tempString componentsSeparatedByString:@"+"] objectAtIndex:0];
    NSDate *currentDate = [dateFormatter dateFromString:date];
    return [currentDate displayTimeSinceNow];
}

@end
