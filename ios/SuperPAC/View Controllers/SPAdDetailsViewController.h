//
//  SPAdDetailsViewController.h
//  SuperPAC
//
//  Created by Andrew Tremblay on 7/24/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPDataManager.h" 
#import "SPVoodooView.h" 

@interface SPAdDetailsViewController : UIViewController <UIActionSheetDelegate, UIWebViewDelegate, SPDataManagerDelegate, SPVoodooViewDelegate>

@property (strong, nonatomic) NSDictionary *adDataDict;
@property (strong, nonatomic) NSDictionary *committeeDataDict;
@property (strong, nonatomic) IBOutlet UIButton *upperLeftTagButton;
@property (strong, nonatomic) IBOutlet UIButton *lowerLeftTagButton;
@property (strong, nonatomic) IBOutlet UIButton *lowerRightTagButton;
@property (strong, nonatomic) IBOutlet UIButton *upperRightTagButton;
@property (weak, nonatomic) IBOutlet UIImageView *tagButtonTopLine;
@property (weak, nonatomic) IBOutlet UIImageView *tagButtonVerticalDivider;
- (IBAction)tagButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *adImageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *adVideoLoadingSpinner;

@property (strong, nonatomic) IBOutlet UIButton *adVideoButton;
@property (strong, nonatomic) IBOutlet UIWebView *adYoutubeWebView;
@property (strong, nonatomic) IBOutlet UIImageView *videoPlaceholderImageView;
@property (strong, nonatomic) IBOutlet SPVoodooView *adVideoVoodooView;
- (IBAction)adVideoButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *moneyWrapperView;
@property (strong, nonatomic) IBOutlet UIView *buttonClusterWrapperView;
@property (strong, nonatomic) IBOutlet UIView *topWrapperView;

@property (strong, nonatomic) IBOutlet UILabel *moneyRaisedStaticLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyRaisedAmountLabel;

@property (strong, nonatomic) IBOutlet UILabel *moneySpentStaticLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneySpentAmountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moneyBackground;

@property (weak, nonatomic) IBOutlet UILabel *pacDataPointOne;
@property (weak, nonatomic) IBOutlet UILabel *pacDataPointTwo;
@property (weak, nonatomic) IBOutlet UIImageView *pacStarTwo;
@property (weak, nonatomic) IBOutlet UIImageView *pacStarOne;


@property (strong, nonatomic) IBOutlet UIView *voteResultsWrapperView;
@property (strong, nonatomic) IBOutlet UIButton *firstPositionButton;
@property (strong, nonatomic) IBOutlet UILabel *firstPositionPercentageLabel;

@property (strong, nonatomic) IBOutlet UIButton *secondPositionButton;
@property (strong, nonatomic) IBOutlet UIButton *thirdPositionButton;
@property (strong, nonatomic) IBOutlet UIButton *fourthPositionButton;

@property (strong, nonatomic) IBOutlet UIButton *sourcesButton;
@property (strong, nonatomic) IBOutlet UIButton *sourcesDisclosureButton;

- (IBAction)sourcesButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *adTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *commiteeNameLabel;

-(void)pushResultsWrapperView:(BOOL)animated;

@property (strong, nonatomic) IBOutlet UIView *taggingProgressWrapperView;

- (IBAction)tagButtonTouchedDown:(id)sender;
- (IBAction)tagButtonTouchFinished:(id)sender;

@end
