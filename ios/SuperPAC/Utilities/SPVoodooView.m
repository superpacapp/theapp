//
//  SPVoodooView.m
//  SuperPAC
//
//  Created by Andrew Tremblay on 7/31/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import "SPVoodooView.h"

@implementation SPVoodooView

@synthesize delegate = _delegate;
@synthesize webView = _webView;
@synthesize videoButton = _videoButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if(self.webView){
        hitView = [self.webView hitTest:point withEvent:event];
    }    
    
    if(self.delegate){
        [self.delegate voodooViewHit];
    }else if(self.videoButton){
        [self.videoButton setSelected:YES];
    }
    
    return hitView;
}


@end
