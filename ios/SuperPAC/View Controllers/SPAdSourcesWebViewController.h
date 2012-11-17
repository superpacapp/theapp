//
//  SPAdSourcesWebViewController.h
//  SuperPAC
//
//  Created by Andrew Khatutsky on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPAdSourcesWebViewController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem* backButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem* forwardButton;
@property (nonatomic, weak) IBOutlet UINavigationItem* navBar;
@property (nonatomic, strong) NSString* titleString;

- (id) initWithUrl:(NSString *)urlString Title:(NSString *)titleString;

- (IBAction)safariLaunch:(id)sender;
- (IBAction)dismissWebView:(id)sender;

@end
