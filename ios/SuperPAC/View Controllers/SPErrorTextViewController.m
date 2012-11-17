//
//  SPErrorTextViewController.m
//  SuperPAC
//
//  Created by Alex Rouse on 7/24/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import "SPErrorTextViewController.h"
#import "LocalyticsSession.h"
#import "SPAnalyticsHelpers.h"
#import "RZWebServiceRequest.h"

#define kDefaultTextViewText    @"Please enter any aditional info that will help us track down this ad."

@interface SPErrorTextViewController ()
//Localytics helpers
-(void)logErrorFormSubmission;
@property (nonatomic, weak) RZWebServiceRequest* webRequest;
@end

@implementation SPErrorTextViewController
@synthesize textView = _textView;
@synthesize parameters = _parameters;
@synthesize spinner = _spinner;

@synthesize webRequest = _webRequest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView.textColor = [UIColor lightGrayColor];
    self.textView.text = kDefaultTextViewText;
    self.textView.selectedRange = NSMakeRange(0, 0);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleDone target:self action:@selector(submitPressed)];
    //Need a custom Back Button :(
    self.navigationItem.leftBarButtonItem = [self makeLeftBarButton];

    [[self textView] becomeFirstResponder];
    
}


-(UIBarButtonItem *)makeLeftBarButton 
{
    // should pick up uiappearance for other attributes
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    
    [leftButton setBackgroundImage:[[UIImage imageNamed:@"navbar_back_button_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 11)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [leftButton setBackgroundImage:[[UIImage imageNamed:@"navbar_back_button_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12, 0, 11)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    [leftButton setTitlePositionAdjustment:UIOffsetMake(4, 0) forBarMetrics:UIBarMetricsDefault];
    return leftButton;
}

- (void)backButtonPressed {
    if (self.webRequest != nil) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"This will stop you from sending us this info." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark UITextViewDelegate 

- (void)textViewDidChange:(UITextView *)textView {
    if([textView.text isEqualToString:kDefaultTextViewText]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([textView.text isEqualToString:kDefaultTextViewText]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}
- (void)submitPressed {
    [self.spinner startAnimating];
    [self.textView setUserInteractionEnabled:NO];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self logErrorFormSubmission];
    
    if (self.textView.text.length > 0)
    {
        [self.parameters setObject:self.textView.text forKey:kFailedComments];
    }
    self.webRequest = [[SPDataManager sharedInstance] postAdFailedWithInfo:self.parameters delegate:self];
}

#pragma mark - SPDataManagerDelegate
- (void)postAdFailedFinishedWithResponse:(NSDictionary *)dict error:(NSError *)error {
    [self.spinner stopAnimating];
    [self.textView setUserInteractionEnabled:YES];
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    self.webRequest = nil;
    
    
    // Both of these need copy
    if (error != nil) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Submission Failed" message:@"There was a problem submiting your data, please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Thanks!" message:@"We'll do our best to find this ad and add it to our database." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [self dismissModalViewControllerAnimated:YES];
    }
}


#pragma mark - Localytics helpers
-(void)logErrorFormSubmission
{
    NSString *allowLocation = ([self.parameters objectForKey:kFailedLat] == nil ? @"No" : @"Yes");
    NSString *taggedValues = [NSString stringWithFormat:@"%@ %@", [self.parameters objectForKey:kFailedSide], [self.parameters objectForKey:@"Candidate"]];
    NSString *side = [self.parameters objectForKey:kFailedSide];
    NSString *candidate = [self.parameters objectForKey:kFailedCandidate];
    NSString *enteredText = ([self.textView.text isEqualToString:kDefaultTextViewText] ? @"No" : @"Yes");
    NSDictionary *attributes = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                        allowLocation, @"Allow location", 
                                                        side, @"Side",
                                                        candidate, @"Candidate",
                                                        taggedValues, @"Tagged Value Combos",
                                                        enteredText, @"Entered Additional Info", nil];
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Error Form Submitted" attributes:attributes];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        [self.webRequest cancel];
        [self.navigationController popViewControllerAnimated:YES];    
    }
    
}


@end
