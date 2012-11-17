//
//  SPTaggedAdModel.h
//  SuperPAC
//
//  Created by Nick Donaldson on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#define kMapPinCenterOffsetX    -4.0f
#define kMapPinCenterOffsetY    18.0f

@interface SPTaggedAdModel : NSObject <MKAnnotation>

@property (nonatomic, strong)   NSDictionary *ad;
@property (nonatomic, readonly) MKAnnotationView *annotationView;

- (id)initWithAd:(NSDictionary*)ad;

@end
