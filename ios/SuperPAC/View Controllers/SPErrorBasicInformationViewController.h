//
//  SPErrorBasicInformationViewController.h
//  SuperPAC
//
//  Created by Alex Rouse on 7/24/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SPDataManager.h"

@interface SPErrorBasicInformationViewController : UIViewController <CLLocationManagerDelegate, SPDataManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *supportsObamaButton;
@property (weak, nonatomic) IBOutlet UIButton *supportsRomneyButton;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView* spinner;
@property (nonatomic, weak) IBOutlet UIButton* locationAllow;

- (IBAction)locationAllow:(id)sender;

- (IBAction)supportRomneyPressed:(id)sender;
- (IBAction)supportObamaPressed:(id)sender;


@end
