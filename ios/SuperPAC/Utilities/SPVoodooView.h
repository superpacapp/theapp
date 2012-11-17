//
//  SPVoodooView.h
//  SuperPAC
//
//  Created by Andrew Tremblay on 7/31/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPVoodooViewDelegate;

@protocol SPVoodooViewDelegate <NSObject>
    -(void)voodooViewHit;

@end

@interface SPVoodooView : UIView
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) id<SPVoodooViewDelegate> delegate;

@end
