//
//  SPBrowseAdsCell.h
//  SuperPAC
//
//  Created by Nick Donaldson on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RZWebServiceRequest;

@interface SPBrowseAdsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@property (weak, nonatomic) IBOutlet UIImageView *alreadyVotedOverlayImage;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;
@property (weak, nonatomic) IBOutlet UIView *imageBorderView;
@property (weak, nonatomic) IBOutlet UILabel *adTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinner;
@property (weak, nonatomic) IBOutlet UIImageView *selectedOverlay;
@property (weak, nonatomic) IBOutlet UILabel *vidLengthLabel;

@property (strong, nonatomic) IBOutlet UILabel *dateUploadedLabel;

-(void)setAd:(NSDictionary*)ad whileVisible:(BOOL)visible;
-(void)updateTagDisplay;

@property (nonatomic, strong) NSDictionary *ad;
@property (nonatomic, strong) RZWebServiceRequest *adDetailRequest;
@property (assign, nonatomic) BOOL loading;

@end
