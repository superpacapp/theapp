//
//  SPShareController.h
//  SuperPAC
//
//  Created by Alex Rouse on 7/24/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>
#import "FBConnect.h"

@interface SPShareController : NSObject <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, FBDialogDelegate>

@property (nonatomic, weak) Facebook* facebook;
@property (nonatomic, strong) NSDictionary* currentAd;
@property (nonatomic, strong) NSDictionary* currentClaim;
@property (nonatomic, assign) BOOL isClaim;
+(SPShareController*)sharedInstance;


- (void)composeEmailForAd:(NSDictionary *)ad withImage:(UIImage *)detailsImage;
- (void)composeTweetForAd:(NSDictionary *)ad withImage:(UIImage *)detailsImage;
- (void)composeMessageForAd:(NSDictionary *)ad;
- (void)composeFacebookForAd:(NSDictionary *)ad;
//- (void)composeEmailForClaim:(NSDictionary *)claim withImage:(UIImage *)detailsImage;
//- (void)composeTweetForClaim:(NSDictionary *)claim withImage:(UIImage *)detailsImage;
//- (void)composeMessageForClaim:(NSDictionary *)claim;
//- (void)composeFacebookForClaim:(NSDictionary *)claim;
@end
