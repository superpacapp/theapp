//
//  SPErrorTextViewController.h
//  SuperPAC
//
//  Created by Alex Rouse on 7/24/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SPDataManager.h"

@interface SPErrorTextViewController : UIViewController <UITextViewDelegate, UIAlertViewDelegate, SPDataManagerDelegate>

@property (nonatomic, weak) IBOutlet UITextView* textView;
@property (nonatomic, strong) NSMutableDictionary* parameters;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView* spinner;

@end
