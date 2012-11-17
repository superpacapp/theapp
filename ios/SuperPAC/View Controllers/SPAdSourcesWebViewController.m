//
//  SPAdSourcesWebViewController.m
//  SuperPAC
//
//  Created by Andrew Khatutsky on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SPAdSourcesWebViewController.h"
#import "LocalyticsSession.h"

@interface SPAdSourcesWebViewController ()
@property (nonatomic, strong) NSString* urlToLoad;
@end

@implementation SPAdSourcesWebViewController
@synthesize webView = _webView;
@synthesize backButton = _backButton;
@synthesize forwardButton = _forwardButton;
@synthesize urlToLoad = _urlToLoad;
@synthesize titleString = _titleString;
@synthesize navBar = _navBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithUrl:(NSString *)urlString Title:(NSString *)titleString{
    self = [super init];
    if(self) {
        self.urlToLoad = urlString;
        self.titleString = titleString;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.webView.scalesPageToFit = YES; //this is now handled in the xib
    [self loadUrl:self.urlToLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //Localytics "Source Web Details" (screen)
    [[LocalyticsSession sharedLocalyticsSession] tagScreen:@"Source Web Details"];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)dismissWebView:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)safariLaunch:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Open in Safari" 
                                                    message:@"Would you like to open this website in Safari?" 
                                                   delegate:self 
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
//    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    if(buttonIndex == 1){
        if (![[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:self.urlToLoad]]){
            LogError(@"%@",@"Failed to open url");
        }
    }
}

- (void)updateButtons
{
    self.forwardButton.enabled = self.webView.canGoForward;
    self.backButton.enabled = self.webView.canGoBack;
}

-(void)loadUrl:(NSString *)urlString{
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.navBar.title = self.titleString;
    [self updateButtons];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - WebView Delegate Methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateButtons];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([error code] != NSURLErrorCancelled) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self updateButtons];
        LogError(@"Error: %@", error);
    }
}

@end
