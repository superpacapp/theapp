//
//  SPErrorBasicInformationViewController.m
//  SuperPAC
//
//  Created by Alex Rouse on 7/24/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import "SPErrorBasicInformationViewController.h"
#import "SPErrorTextViewController.h"

@interface SPErrorBasicInformationViewController ()
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, assign) BOOL locationLockOn;
@property (nonatomic, assign) BOOL dataLockOn;
@property (nonatomic, strong) UIBarButtonItem* nextButton;
@property (nonatomic, assign) BOOL candidateSelected;
@property (nonatomic, strong) CLLocation* foundLocation;

@end

@implementation SPErrorBasicInformationViewController
@synthesize supportsObamaButton = _supportsObamaButton;
@synthesize supportsRomneyButton = _supportsRomneyButton;
@synthesize spinner = _spinner;
@synthesize locationAllow = _locationAllow;

@synthesize locationManager = _locationManager;
@synthesize locationLockOn = _locationLockOn;
@synthesize dataLockOn = _dataLockOn;
@synthesize nextButton = _nextButton;
@synthesize candidateSelected = _candidateSelected;
@synthesize foundLocation = _foundLocation;


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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelPressed)];
    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(nextPressed)];
    self.navigationItem.rightBarButtonItem = self.nextButton;
    
    self.dataLockOn = YES;
    self.locationLockOn = NO;
    self.candidateSelected = NO;
    [self setNextButtonEnabled:NO];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setSupportsObamaButton:nil];
    [self setSupportsRomneyButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)setNextButtonEnabled:(BOOL)enabled {
    if(!self.dataLockOn && !self.locationLockOn && enabled) {
        [self.nextButton setEnabled:YES];
    }
    else {
        [self.nextButton setEnabled:NO];
    }
}

- (void)cancelPressed {
    [self dismissModalViewControllerAnimated:YES];
}
- (void)nextPressed {
    SPErrorTextViewController* textVC = [[SPErrorTextViewController alloc] init];

    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithObjectsAndKeys: (self.supportsRomneyButton.selected) ? @"romney" : @"obama", kFailedCandidate, @"support", kFailedSide, nil];
    
    if (self.foundLocation)
    {
        CLLocationCoordinate2D coord = [self.foundLocation coordinate];
        [params setObject:[NSNumber numberWithFloat:coord.latitude] forKey:kFailedLat];
        [params setObject:[NSNumber numberWithFloat:coord.longitude] forKey:kFailedLon];
    }

    textVC.parameters = params;
    //Slow if its the first time that you load the keyboard
    [self.navigationController pushViewController:textVC animated:YES];
}

- (IBAction)locationAllow:(id)sender {
    [self setNextButtonEnabled:NO];
    self.locationAllow.enabled = NO;
    self.locationLockOn = YES;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    [self.spinner startAnimating];
}

- (IBAction)supportObamaPressed:(id)sender
{
    [self.supportsRomneyButton setSelected:NO];
    [self.supportsObamaButton setSelected:YES];
    self.candidateSelected = YES;
    [self updateDataLock];
}

- (IBAction)supportRomneyPressed:(id)sender
{
    [self.supportsRomneyButton setSelected:YES];
    [self.supportsObamaButton setSelected:NO];
    self.candidateSelected = YES;
    [self updateDataLock];
}

- (void)updateDataLock {
    self.dataLockOn = ![self candidateSelected];
    [self setNextButtonEnabled:YES];
}


#pragma mark -CoreLocationDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [self.locationAllow setTitle:@"Location Found" forState:UIControlStateNormal];
    [self.locationAllow setTitle:@"Location Found" forState:UIControlStateDisabled];
    [self.locationAllow setImage:[UIImage imageNamed:@"error_button_checkmark"] forState:UIControlStateNormal];
    [self.locationAllow setImage:[UIImage imageNamed:@"error_button_checkmark"] forState:UIControlStateDisabled];
    self.foundLocation = newLocation;
    [self.spinner stopAnimating];
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
    self.locationLockOn = NO;
    [self setNextButtonEnabled:YES];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    self.locationLockOn = NO;
    [self.spinner stopAnimating];
    self.locationAllow.enabled = YES;
    [self setNextButtonEnabled:YES];
    if ([error code]== kCLAuthorizationStatusRestricted || [error code] == kCLAuthorizationStatusDenied ) 
    {
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You need to enable Location Services for Super PAC App in your device's Settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    
    
}

#pragma mark - SPDataManagerDelegate 
- (void)postAdFailedFinishedWithResponse:(NSDictionary *)dict error:(NSError *)error {
    //We dont want to do anything, this is a hidden request.
}


@end
