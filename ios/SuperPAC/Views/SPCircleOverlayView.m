//
//  SPCircleOverlayView.m
//  SuperPAC
//
//  Created by Nick Donaldson on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SPCircleOverlayView.h"
#import <QuartzCore/QuartzCore.h>

#define kMaxMapSizeToDraw   500000.0

@implementation SPCircleOverlayView

- (id)initWithCircle:(MKCircle *)circle
{
    self = [super initWithCircle:circle];
    if (self){
        self.opaque = NO;
        self.layer.opaque = NO;
        self.fillColor = [UIColor colorWithRed:0.34 green:0.6 blue:1 alpha:0.95];
        self.strokeColor = [UIColor colorWithRed:0.36 green:0.61 blue:0.85 alpha:1];
    }
    return self;
}

- (BOOL)canDrawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale
{
    return mapRect.size.width <= kMaxMapSizeToDraw;
}

@end
    