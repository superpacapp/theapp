//
//  SPErrorPromptViewController.m
//  SuperPAC
//
//  Created by Alex Rouse on 7/24/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import "SPErrorPromptViewController.h"

#import "SPErrorBasicInformationViewController.h"

#import "LocalyticsSession.h"

@interface SPErrorPromptViewController ()

@end

@implementation SPErrorPromptViewController

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
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //Localytics "Error Matching" (screen)
    [[LocalyticsSession sharedLocalyticsSession] tagScreen:@"Error Matching"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (IBAction)noThanksPressed:(id)sender {
    //Localytcs "Error prompt"
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:@"No Thanks", @"Response", nil];
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Error prompt" attributes:attributes];

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)imInPressed:(id)sender {
    //Localytcs "Error prompt"
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:@"Sure", @"Response", nil];
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Error prompt" attributes:attributes];

    SPErrorBasicInformationViewController* vc = [[SPErrorBasicInformationViewController alloc] init];
    UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.parentViewController presentViewController:navVC animated:YES completion:^{
        [self.navigationController popViewControllerAnimated:NO];
    }];

}

@end
