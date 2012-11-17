//
//  SPAppDelegate.m
//  SuperPAC
//
//  Created by Nick Donaldson on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SPAppDelegate.h"
#import "AppBlade.h"

#import "SPNavigationViewController.h"
#import "SPAudioTagViewController.h"
#import "SPBrowseAdsViewController.h"
#import "SPHappeningNowViewController.h"
#import "LocalyticsSession.h"
#import "SPShareController.h"
#import "SPDataManager.h"
#import "SPAnalyticsHelpers.h"

#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioServices.h>

#define SDEM_PRINTOSTYPE(A)	(int)((A)>>24)&0xFF, (int)((A)>>16)&0xFF, (int)((A)>>8)&0xFF, (int)(A)&0xFF

#import "SPAdDetailsViewController.h"



enum {
    SPHappeningNowViewControllerIndex,
    SPAudioTagViewControllerIndex,
    SPBrowseAdsViewControllerIndex
};

enum {
    SPAlertNavigationDuringAdIdentification
};

@interface SPAppDelegate ()
{
    NSInteger _tappedTabIndex;
}

- (void)updateTabBarImageForIndex:(NSInteger)index;

@end

@implementation SPAppDelegate 

@synthesize window = _window;
@synthesize rootTabBarController = _rootTabBarController;
@synthesize facebook = _facebook;
@synthesize audioTagNavController = _audioTagNavController;
@synthesize audioTagViewController = _audioTagViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    LogDebug(@"API Endpoint: %@", API_ENDPOINT);
    
    // AppBlade Integration
    AppBlade *blade = [AppBlade sharedManager];
    blade.appBladeProjectID = @"b07c68a2-dccc-41cc-9539-467a526e9a68";
    blade.appBladeProjectToken = @"08c4c7b10565a47e8680224a72cdfcfc";
    blade.appBladeProjectSecret = @"d54cc94d67168c296ed061d15df9e6b2";
    blade.appBladeProjectIssuedTimestamp = @"1343258471";
    [blade catchAndReportCrashes];

#ifdef RELEASE
    [[LocalyticsSession sharedLocalyticsSession] startSession:@"0fbd0c53e25bc62e9168bb5-e28bdffa-d4d6-11e1-47ad-00ef75f32667"];
#else
    [[LocalyticsSession sharedLocalyticsSession] startSession:@"2cff613949acd5986ec1bbd-a73844f6-e229-11e1-4be8-00ef75f32667"];
#endif
    
    self.facebook = [[Facebook alloc] initWithAppId:FACEBOOK_APPID andDelegate:self];
    [SPShareController sharedInstance].facebook = self.facebook;
    
    
    //Check for first launch
    if(![[SPAnalyticsHelpers shared] hasLaunched]){
        //Localytics "First launch" 
        [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"First launch"];
    }
    
    // Global appearance
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"noisy_navbar_potus_blue"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forBarMetrics:UIBarMetricsDefault];
    UIFont *titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [UIColor colorWithWhite:0.0f alpha:0.4f], UITextAttributeTextShadowColor, CGSizeMake(0, -1), UITextAttributeTextShadowOffset,  titleFont, UITextAttributeFont, nil]];
    
    //TODO: We needs specs for the barbuttons still.  But should just be fill in from here.
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]  setBackgroundImage:[[UIImage imageNamed:@"navbar_button_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 11, 15, 11)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]  setBackgroundImage:[[UIImage imageNamed:@"navbar_button_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 11, 15, 11)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"navbar_back_button_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 12, 15, 11)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"navbar_back_button_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 12, 15, 11)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    

    UIFont *buttonFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];

    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:buttonFont, UITextAttributeFont, [UIColor whiteColor], UITextAttributeTextColor, [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset, [UIColor blackColor], UITextAttributeTextShadowColor, nil] forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:buttonFont, UITextAttributeFont, [UIColor whiteColor], UITextAttributeTextColor, [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset, [UIColor blackColor], UITextAttributeTextShadowColor, nil] forState:UIControlStateHighlighted];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(4,-2) forBarMetrics:UIBarMetricsDefault];

    
    // Create base VC's for each tab
    SPHappeningNowViewController *happeningNowVC = [[SPHappeningNowViewController alloc] initWithNibName:nil bundle:nil];
    SPAudioTagViewController *audioTagVC = [[SPAudioTagViewController alloc] initWithNibName:nil bundle:nil];
    SPBrowseAdsViewController *browseAdsVC = [[SPBrowseAdsViewController alloc] initWithNibName:nil bundle:nil];
    
    // wrap in Nav controllers
    SPNavigationViewController *happeningNowNav = [[SPNavigationViewController alloc] initWithRootViewController:happeningNowVC];
    SPNavigationViewController *audioTagNav = [[SPNavigationViewController alloc] initWithRootViewController:audioTagVC];
    SPNavigationViewController *browseAdsNav = [[SPNavigationViewController alloc] initWithRootViewController:browseAdsVC];
            
    // assign to local properties
    self.audioTagNavController = audioTagNav;
    self.audioTagViewController = audioTagVC;
    
    // Create window, add VC's to tab bar
    self.rootTabBarController = [[UITabBarController alloc] init];
    self.rootTabBarController.delegate = self;    
    
    // tab bar appearance
    [self.rootTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tab_bar_listen_selected.png"]];
    [self.rootTabBarController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"blank_tab_bar_selection"]];
    
    
    [self.rootTabBarController setViewControllers:[NSArray arrayWithObjects:happeningNowNav, audioTagNav, browseAdsNav, nil]];
    [self.rootTabBarController setSelectedIndex:SPAudioTagViewControllerIndex];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.rootTabBarController;
    [self.window makeKeyAndVisible];
    
    // Audio session config for TuneSat
    OSStatus status;
	status=AudioSessionInitialize(NULL, NULL, NULL, NULL);
	if(status) fprintf(stderr, "AudioSessionInitialize: '%c%c%c%c'\n", SDEM_PRINTOSTYPE(status));
    
	UInt32 category=kAudioSessionCategory_RecordAudio;
	status=AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof category, &category);
	if(status) fprintf(stderr, "kAudioSessionProperty_AudioCategory: '%c%c%c%c'\n", SDEM_PRINTOSTYPE(status));
    
	UInt32 mode=kAudioSessionMode_Measurement;
	status=AudioSessionSetProperty(kAudioSessionProperty_Mode, sizeof mode, &mode);
	if(status) fprintf(stderr, "kAudioSessionProperty_Mode: '%c%c%c%c'\n", SDEM_PRINTOSTYPE(status));
    
	UInt32 available;
	UInt32 size=sizeof available;
	status=AudioSessionGetProperty(kAudioSessionProperty_InputGainAvailable, &size, &available);
	if(status) fprintf(stderr, "kAudioSessionProperty_Mode: '%c%c%c%c'\n", SDEM_PRINTOSTYPE(status));
	else{
		if(available){
			Float32 gain=1.;
			status=AudioSessionSetProperty(kAudioSessionProperty_InputGainScalar, sizeof gain, &gain);
			if(status) fprintf(stderr, "kAudioSessionProperty_InputGainScalar: '%c%c%c%c'\n", SDEM_PRINTOSTYPE(status));
		}else fprintf(stderr, "Input gain not available!\n");
	}
    
	status=AudioSessionSetActive(true);
	if(status) fprintf(stderr, "AudioSessionSetActive: '%c%c%c%c'\n", SDEM_PRINTOSTYPE(status));
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self.facebook handleOpenURL:url]; 
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kWillResignActiveNotification object:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidEnterBackgroundNotification object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[LocalyticsSession sharedLocalyticsSession] resume];
    [[LocalyticsSession sharedLocalyticsSession] upload];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kWillEnterForegroundNotification object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if(![[SPDataManager sharedInstance] networkReachable]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Network Required"
                              message: @"Super PAC App requires an internet connection."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[SPDataManager sharedInstance] clearCachedData];
}

- (void)updateTabBarImageForIndex:(NSInteger)index
{
    NSString *bgImageName = nil;
    switch (index) {
        case SPHappeningNowViewControllerIndex:
            bgImageName = @"tab_bar_now_selected";
            break;
            
        case SPAudioTagViewControllerIndex:
            bgImageName = @"tab_bar_listen_selected";
            break;
            
        case SPBrowseAdsViewControllerIndex:
            bgImageName = @"tab_bar_ads_selected";
        default:
            break;
    }
    
    if (bgImageName)
        [self.rootTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:bgImageName]];
}


#pragma mark - UITabbarController delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (viewController != _audioTagNavController && _audioTagViewController.identificationInProgress)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                        message:@"This will stop us from identifying the ad."
                                                       delegate:self
                                              cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        
        [alert setTag:SPAlertNavigationDuringAdIdentification];
        [alert show];
        _tappedTabIndex = [[tabBarController viewControllers] indexOfObject:viewController];
        return NO;
    }
    _tappedTabIndex = -1;
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSInteger tabIndex = [[tabBarController viewControllers] indexOfObject:viewController];
    
    NSString *tabPressed = @"";;
    switch (tabIndex) {
        case SPHappeningNowViewControllerIndex:
            tabPressed = @"Happening Now";
            break;
            
        case SPAudioTagViewControllerIndex:
            tabPressed = @"Listen";
            break;
            
        case SPBrowseAdsViewControllerIndex:
            tabPressed = @"More Ads";
        default:
            break;
    }
    
    [self updateTabBarImageForIndex:tabIndex];
    
    //Localytics "Tab pressed" 
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:tabPressed, @"Tab pressed", nil];
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Tab pressed" attributes:attributes];
        
}

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == SPAlertNavigationDuringAdIdentification)
    {
        if (buttonIndex > 0 && _tappedTabIndex >= 0 && _tappedTabIndex < 3)
        {
            [self.rootTabBarController setSelectedIndex:_tappedTabIndex];
            [self updateTabBarImageForIndex:_tappedTabIndex];
            _tappedTabIndex = -1;
        }
    }
}


#pragma mark - Facebook delegate
- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[self.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    if ([[SPShareController sharedInstance] currentAd] != nil) {
        [[SPShareController sharedInstance] composeFacebookForAd:nil];
    }
}
- (void)fbDidNotLogin:(BOOL)cancelled {
    
}
- (void)fbDidLogout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"FBAccessTokenKey"];
    [defaults setObject:nil forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}
- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt { //set new token and expiration
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)fbSessionInvalidated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"FBAccessTokenKey"];
    [defaults setObject:nil forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}


@end
