//
//  SPAppDelegate.h
//  SuperPAC
//
//  Created by Nick Donaldson on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class SPViewController;
@class SPAudioTagViewController;
@class SPNavigationViewController;

@interface SPAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UIAlertViewDelegate, FBSessionDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *rootTabBarController;
@property (strong, nonatomic) Facebook *facebook;

// keep track of these so we can detect navigation away while identifying song
@property (strong, nonatomic) SPNavigationViewController *audioTagNavController;
@property (strong, nonatomic) SPAudioTagViewController *audioTagViewController;

@end
