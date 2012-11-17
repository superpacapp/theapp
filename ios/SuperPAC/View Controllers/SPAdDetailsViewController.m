//
//  SPAdDetailsViewController.m
//  SuperPAC
//
//  Created by Andrew Tremblay on 7/24/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import "SPAdSourcesViewController.h"
#import "SPAdDetailsViewController.h"
#import "SPShareController.h"

#import "NSDictionary+Ad.h"
#import "NSDictionary+Committee.h"
#import "LocalyticsSession.h"

#import "NSData+ValidJPEG.h"


enum {
    SPAdDetailsShareActionSheetIndexEmail = 0,
    SPAdDetailsShareActionSheetIndexSms = 1,
    SPAdDetailsShareActionSheetIndexTwitter = 2,
    SPAdDetailsShareActionSheetIndexFacebook = 3
};
typedef NSUInteger SPAdDetailsShareActionSheetIndex;


@interface SPAdDetailsViewController () 
    -(void)setDisplayFromConstants;
    -(void)buildNavigationButtons;
    -(void)displayShareActionSheet;
    -(void)backButtonPressed;
    -(void)setPageLayout;


    -(void)displayVotingModal:(BOOL)animated;

    -(void)embedYouTube:(NSString*)url frame:(CGRect)frame;

@property (nonatomic, strong) NSString *adTaggedVal; 


-(void)setFirstPositionButtonForTag:(NSDictionary *)tag;
-(void)setSmallButton:(UIButton *)button forTag:(NSDictionary *)tag;

    //API helpers
    -(void)initiateTagRequestWithValue:(NSString *)tagValue; 

@end

@implementation SPAdDetailsViewController
@synthesize taggingProgressWrapperView = _taggingProgressWrapperView;
@synthesize adTitleLabel = _adTitleLabel;
@synthesize commiteeNameLabel = _commiteeNameLabel;

@synthesize adVideoVoodooView = _adVideoVoodooView;
@synthesize moneyWrapperView = _moneyWrapperView;
@synthesize buttonClusterWrapperView = _buttonClusterWrapperView;
@synthesize topWrapperView = _topWrapperView;
@synthesize moneyRaisedStaticLabel = _moneyRaisedStaticLabel;
@synthesize moneyRaisedAmountLabel = _moneyRaisedAmountLabel;
@synthesize moneySpentStaticLabel = _moneySpentStaticLabel;
@synthesize moneySpentAmountLabel = _moneySpentAmountLabel;
@synthesize moneyBackground = _moneyBackground;
@synthesize pacDataPointOne = _pacDataPointOne;
@synthesize pacDataPointTwo = _pacDataPointTwo;
@synthesize pacStarTwo = _pacStarTwo;
@synthesize pacStarOne = _pacStarOne;
@synthesize voteResultsWrapperView = _voteResultsWrapperView;
@synthesize firstPositionButton = _firstPositionButton;
@synthesize firstPositionPercentageLabel = _firstPositionPercentageLabel;
@synthesize secondPositionButton = _secondPositionButton;
@synthesize thirdPositionButton = _thirdPositionButton;
@synthesize fourthPositionButton = _fourthPositionButton;

@synthesize adImageView = _adImageView;
@synthesize adVideoButton = _adVideoButton;
@synthesize adYoutubeWebView = _adYoutubeWebView;
@synthesize videoPlaceholderImageView = _videoPlaceholderImageView;

@synthesize adVideoLoadingSpinner = _adVideoLoadingSpinner;
@synthesize adTaggedVal = _adTaggedVal;



@synthesize adDataDict = _adDataDict;
@synthesize committeeDataDict = _committeeDataDict;
@synthesize upperLeftTagButton = _upperLeftTagButton;
@synthesize lowerLeftTagButton = _lowerLeftTagButton;
@synthesize lowerRightTagButton = _lowerRightTagButton;
@synthesize upperRightTagButton = _upperRightTagButton;
@synthesize tagButtonTopLine = _tagButtonTopLine;
@synthesize tagButtonVerticalDivider = _tagButtonVerticalDivider;
@synthesize sourcesButton = _sourcesButton;
@synthesize sourcesDisclosureButton = _sourcesDisclosureButton;

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
    self.title = @"Ad Details";
    //resize buttons
    [self buildNavigationButtons];
    [self setDisplayFromConstants];

    [self.adVideoVoodooView setDelegate:self];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setAdDataDict:self.adDataDict];
    [self.adVideoButton setSelected:NO];

    self.title = @"Ad Details";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //Localytics "Ad Details" (screen)
    [[LocalyticsSession sharedLocalyticsSession] tagScreen:@"Ad Details"];
    [self setPageLayout];
    
    //request an update of the tag data, silently update or fail on return (NICE TO HAVE)
//    [[SPDataManager sharedInstance] getAdDetailsForAdId:[self.adDataDict adId]  withDelegate:self];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.adVideoButton setSelected:NO];
    if(self.taggingProgressWrapperView && self.taggingProgressWrapperView.superview){
        [self.taggingProgressWrapperView removeFromSuperview];
    }
}

- (void)viewDidUnload
{
    [self setUpperLeftTagButton:nil];
    [self setLowerLeftTagButton:nil];
    [self setLowerRightTagButton:nil];
    [self setUpperRightTagButton:nil];
    [self setAdTitleLabel:nil];
    [self setCommiteeNameLabel:nil];
    [self setSourcesButton:nil];
    [self setMoneyRaisedStaticLabel:nil];
    [self setMoneySpentStaticLabel:nil];
    [self setMoneyRaisedAmountLabel:nil];
    [self setMoneySpentAmountLabel:nil];
    [self setTagButtonTopLine:nil];
    [self setTagButtonVerticalDivider:nil];
    [self setMoneyBackground:nil];
    [self setPacDataPointOne:nil];
    [self setPacDataPointTwo:nil];
    [self setPacStarTwo:nil];
    [self setPacStarOne:nil];
    [self setVoteResultsWrapperView:nil];
    [self setFirstPositionButton:nil];
    [self setSecondPositionButton:nil];
    [self setThirdPositionButton:nil];
    [self setFourthPositionButton:nil];
    [self setTaggingProgressWrapperView:nil];
    [self setVideoPlaceholderImageView:nil];
    [self setAdYoutubeWebView:nil];
    self.adVideoVoodooView.delegate = nil;
    [self setAdVideoVoodooView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    
}


-(void)buildNavigationButtons //back button handle elsewhere
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(displayShareActionSheet)]; 
    self.navigationItem.rightBarButtonItem = shareButton;
    
}



-(void)setDisplayFromConstants
{
    [self.commiteeNameLabel setTextColor:kSPBlueTextColor];
    
    [self.pacDataPointOne setTextColor:kSPBlueTextColor];
    [self.pacDataPointTwo setTextColor:kSPBlueTextColor];

    [self.adTitleLabel setTextColor:kSPBlueTextColor];

    [self.sourcesButton setTitleColor:kSPBlueTextColor forState:UIControlStateNormal];

    self.moneyBackground.image = [UIImage imageNamed:@"details_red_bar.png"];
}


-(void)setAdDataDict:(NSDictionary *)adDataDict
{
    _adDataDict = adDataDict;
    self.committeeDataDict = [adDataDict committee];
    
    //set delegate (tentatively)
    
    NSString *tagCheck = [[SPDataManager sharedInstance] tagForAdId:[self.adDataDict adId]];
    if(tagCheck){
        [self pushResultsWrapperView:NO];
    }
}

-(void)setCommitteeDataDict:(NSDictionary *)committeeDataDict{
    _committeeDataDict = committeeDataDict;
}

- (void)setPageLayout{
    //resize the number of pac data 
    NSArray *committeeAffiliateTitles = [self.committeeDataDict committeeOrgTypeSuppOpp];
    
    //TODO populate with real data when format is available

    [self.pacDataPointOne setHidden:YES];
    [self.pacStarOne setHidden:YES];
    [self.pacDataPointTwo setHidden:YES];
    [self.pacStarTwo setHidden:YES];

    if([committeeAffiliateTitles count] > 0)
    {
        [self.pacDataPointOne setHidden:NO];
        [self.pacStarOne setHidden:NO];
        [self.pacDataPointOne setText:[committeeAffiliateTitles objectAtIndex:0]];
    }
    if ([committeeAffiliateTitles count] > 1) {
        [self.pacDataPointTwo setHidden:NO];
        [self.pacStarTwo setHidden:NO];
        [self.pacDataPointTwo setText:[committeeAffiliateTitles objectAtIndex:1]];
    }
    
    [self.adTitleLabel setNumberOfLines:2];
    CGRect newAdTitleFrame = self.adTitleLabel.frame;
    if(self.pacDataPointTwo.isHidden)
    {
        CGFloat ydelta = newAdTitleFrame.origin.y - self.pacDataPointTwo.frame.origin.y;
        newAdTitleFrame.size.height += ydelta; 
        newAdTitleFrame.origin.y -= ydelta;
        [self.adTitleLabel setNumberOfLines:3];
    }
    if(self.pacDataPointOne.isHidden)
    {
        CGFloat ydelta = newAdTitleFrame.origin.y - (self.commiteeNameLabel.frame.origin.y + self.commiteeNameLabel.frame.size.height);
        newAdTitleFrame.size.height += ydelta; 
        newAdTitleFrame.origin.y -= ydelta;        
        [self.adTitleLabel setNumberOfLines:4];
    }
    NSString *adTitle =[NSString stringWithFormat:@"Ad: %@", [self.adDataDict adTitle]];
    CGSize textSize = [adTitle sizeWithFont:self.adTitleLabel.font constrainedToSize:newAdTitleFrame.size lineBreakMode:UILineBreakModeWordWrap];
    newAdTitleFrame.size.width = textSize.width;
    newAdTitleFrame.size.height = textSize.height;
    
    self.adTitleLabel.frame = newAdTitleFrame;
    [self.adTitleLabel setText: adTitle];
    
    // committee information
    [self.commiteeNameLabel setText:self.committeeDataDict.committeeName];
    
    //set the  data 
//    [self.adImageView setImage:[UIImage imageNamed:@"noisy_gray_background.png"]]; //set default Image
    //hook up money
    [self.moneyRaisedAmountLabel setText:[self.committeeDataDict committeeTotalRaised]];
    [self.moneySpentAmountLabel setText:[self.committeeDataDict committeeTotalSpent]];

    //enable/disable claims button
    if([[[self adDataDict] adClaims] count] > 0){
        [self.sourcesButton setEnabled:YES];         
        [self.sourcesButton setTitle:@"See claims made in this ad" forState:UIControlStateNormal];
        [self.sourcesDisclosureButton setHidden:NO];
        [self.sourcesDisclosureButton setEnabled:YES];         
    }else{
        [self.sourcesButton setEnabled:NO]; 
        [self.sourcesButton setTitle:@"No specific claim found in this ad." forState:UIControlStateNormal];
        [self.sourcesDisclosureButton setHidden:YES];
        [self.sourcesDisclosureButton setEnabled:NO];         
    }
    
    
    //begin cached loading of images (TODO)
    NSString *thumbnailURL = [self.adDataDict thumbnailUrl];
    if(thumbnailURL){
        RZFileManager *fm = [[SPDataManager sharedInstance] imageFileManager];
        [fm downloadFileFromURL:[NSURL URLWithString:thumbnailURL]
           withProgressDelegate:nil
                     completion:^(BOOL success, NSURL *downloadedFile, RZWebServiceRequest *request) {
                         if (success){

                                 // check bad JPEG
                                 NSData* imgData = [NSData dataWithContentsOfURL:downloadedFile];
                                 if ([imgData isValidJPEG]){
                                     UIImage *image = [UIImage imageWithData:imgData];
                                     [self.adImageView setImage:image];
                                 }
                                 else{
                                     [[RZFileManager defaultManager] deleteFileFromCacheWithURL:downloadedFile];
                                 }
                                     
                             }
                         }];
    }
    
    // hide voodoo for iOS 6 - sadly no youtube support
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0){
        //load webview silently in the shadows
        NSString *youtubeLink = [self.adDataDict youtubeUrl];
        if(youtubeLink){ //@"http://www.youtube.com/watch?v=iDP4qrA8hvg"
            [self.adVideoLoadingSpinner setHidden:NO];
            [self.adVideoButton setHidden:YES];
            [self embedYouTube:youtubeLink frame:self.adImageView.frame];
        }else{
            [self.adVideoButton setHidden:YES];
        }
    }
    else{
        [self.adVideoLoadingSpinner setHidden:YES];
        [self.adVideoVoodooView removeFromSuperview];
        [self.adVideoButton setUserInteractionEnabled:YES];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


//UI Interaction
- (IBAction)sourcesButtonPressed:(id)sender {
    //Localytics "See Claims Pressed" 
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"See Claims pressed"];    
    
    
    SPAdSourcesViewController *adSources = [[SPAdSourcesViewController alloc] initWithNibName:nil bundle:nil];
    adSources.hidesBottomBarWhenPushed = NO;
    adSources.currentAd = self.adDataDict;

    //pass the claims data 
    [self.navigationController pushViewController:adSources animated:YES];
}

- (IBAction)tagButtonPressed:(id)sender {
    LogDebug(@"%@ pressed", sender);
    self.adTaggedVal = nil; 

    if([self.upperLeftTagButton isEqual:sender]){
        //LOVE
        self.adTaggedVal = @"Love";
        [self initiateTagRequestWithValue:kAdTagLove];
    }else if([self.upperRightTagButton isEqual:sender]){
        //FAIR
        self.adTaggedVal = @"Fair";
        [self initiateTagRequestWithValue:kAdTagFair];
    }else if([self.lowerLeftTagButton isEqual:sender]){
        //FISHY
        self.adTaggedVal = @"Fishy";
        [self initiateTagRequestWithValue:kAdTagFishy];
    }else if([self.lowerRightTagButton isEqual:sender]){
         //Fail
        self.adTaggedVal = @"Fail";
        [self initiateTagRequestWithValue:kAdTagFail];
    }else{
        LogError(@"No behavior for %@", sender);
        return;
    }
  
    [self tagButtonTouchFinished:sender];

    //Localytics "Ad tagged" 
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.adTaggedVal, @"Opinion", nil];
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Ad tagged" attributes:attributes];    
}

- (IBAction)adVideoButtonPressed:(id)sender
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0){
        NSString *youtubeLink = [self.adDataDict youtubeUrl];
        if (youtubeLink)
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:youtubeLink]];
    }
}


- (void)embedYouTube:(NSString*)url frame:(CGRect)frame {  
    NSString* embedHTML = @"<html><head><style type=\"text/css\">body {background-color: black;color: white;}</style></head><body style=\"margin:0\"><embed id=\"yt\" src=\"%@&showinfo=0\" type=\"application/x-shockwave-flash\"width=\"%0.0f\" height=\"%0.0f\"></embed></body></html>";  
    NSString* html = [NSString stringWithFormat:embedHTML, url, frame.size.width, frame.size.height];  
    self.adYoutubeWebView.scrollView.scrollEnabled = NO;
    self.adYoutubeWebView.delegate = self;
    [self.adYoutubeWebView setAlpha:1.0];
    [self.adYoutubeWebView loadHTMLString:html baseURL:nil];  
}


-(void)backButtonPressed{
    LogDebug(@"back pressed");
    [[self navigationController] popViewControllerAnimated:YES];
}


-(void)pushResultsWrapperView:(BOOL)animated
{
    if([self.voteResultsWrapperView superview]){
        [self.voteResultsWrapperView removeFromSuperview];
    }
    
    
    CGRect initialFrame = self.voteResultsWrapperView.frame;
    initialFrame.origin.x = self.voteResultsWrapperView.frame.size.width; //(always 320 but no magic numbers) 
    initialFrame.origin.y = self.buttonClusterWrapperView.frame.origin.y;
    self.voteResultsWrapperView.frame = initialFrame; 
    [[self view] addSubview:self.voteResultsWrapperView]; //add offscreeen and in position
    

    //set the values     
    NSArray *orderedTags = [self.adDataDict sortedTags]; //always returns an array
    if([orderedTags count] > 0){
        [self setFirstPositionButtonForTag:[orderedTags objectAtIndex:0]];
        [self setSmallButton:self.secondPositionButton forTag:[orderedTags objectAtIndex:1]];
        [self setSmallButton:self.thirdPositionButton forTag:[orderedTags objectAtIndex:2]];
        [self setSmallButton:self.fourthPositionButton forTag:[orderedTags objectAtIndex:3]];
    }
    //Do we want to let them revote? Keep them as buttons.
    [self.firstPositionButton setEnabled:NO];
    [self.secondPositionButton setEnabled:NO];
    [self.thirdPositionButton setEnabled:NO];
    [self.fourthPositionButton setEnabled:NO];
    
    CGRect destinationFrame = self.voteResultsWrapperView.frame;
    destinationFrame.origin.x = 0;

    //animate into view (or just pop it in)
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            self.buttonClusterWrapperView.frame = CGRectMake(-self.buttonClusterWrapperView.frame.size.width, self.buttonClusterWrapperView.frame.origin.y, self.buttonClusterWrapperView.frame.size.width, self.buttonClusterWrapperView.frame.size.height);
            self.voteResultsWrapperView.frame = destinationFrame;
        } completion:^(BOOL finished){}];        
    }else {
        self.voteResultsWrapperView.frame = destinationFrame;
    }
}

-(void)setFirstPositionButtonForTag:(NSDictionary *)tag
{
    [self.firstPositionButton setTitle:[tag objectForKey:@"tagTitle"] forState:UIControlStateNormal];
    [self.firstPositionButton setImage:[UIImage imageNamed:[tag objectForKey:@"tagImageUrl"]] forState:UIControlStateNormal];
    
    [self.firstPositionPercentageLabel setText:[NSString stringWithFormat:@"%@", [tag objectForKey:@"tagPercent"] ]];  
}
-(void)setSmallButton:(UIButton *)button forTag:(NSDictionary *)tag
{
    [button setTitle:[NSString stringWithFormat:@"%@ %@", [tag objectForKey:@"tagPercent"], [tag objectForKey:@"tagTitle"]] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:[tag objectForKey:@"tagImageUrl"]] forState:UIControlStateNormal];
    [button setContentMode:UIViewContentModeLeft];
}


-(void)displayVotingModal:(BOOL)animated
{
    if([self.taggingProgressWrapperView superview]){
        [self.taggingProgressWrapperView removeFromSuperview];
    }
    self.taggingProgressWrapperView.alpha = 0.0;
    self.taggingProgressWrapperView.frame = self.buttonClusterWrapperView.frame;
    [[self view] addSubview:self.taggingProgressWrapperView];
    if(animated){
        [UIView animateWithDuration:0.3 animations:^(void){
            self.taggingProgressWrapperView.alpha = 0.5;
        }];
    }else {
        self.taggingProgressWrapperView.alpha = 0.5;
    }
}


//API Interaction
-(void)initiateTagRequestWithValue:(NSString *)tagValue 
{
    [self displayVotingModal:YES];
    [[SPDataManager sharedInstance] getCurrentLocationWithCompletionBlock:^(CLLocation *location) {
        [[SPDataManager sharedInstance] postTag:tagValue forAdId:self.adDataDict.adId delegate:self];
    }];
}

//UIActionSheetDelegate
-(void)displayShareActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select a Method to Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email",@"SMS",@"Twitter",@"Facebook", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}


-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    //Localytics "Ad shared" 
    NSString *method = @"";
    [[SPShareController sharedInstance] setIsClaim:NO];
    switch (buttonIndex) {
        case SPAdDetailsShareActionSheetIndexEmail:
            [[SPShareController sharedInstance] composeEmailForAd:self.adDataDict withImage:nil];
            method = @"Email";
            break;
        case SPAdDetailsShareActionSheetIndexSms:
            [[SPShareController sharedInstance] composeMessageForAd:self.adDataDict];
            method = @"SMS";
            break;
        case SPAdDetailsShareActionSheetIndexTwitter:
            [[SPShareController sharedInstance] composeTweetForAd:self.adDataDict withImage:nil];
            method = @"Twitter";
            break;
        case SPAdDetailsShareActionSheetIndexFacebook:
            [[SPShareController sharedInstance] composeFacebookForAd:self.adDataDict];
            method = @"Facebook";
            break;            
        default:
            break;
    }
    if(method.length > 0){
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:method, @"Method", @"Ad Details", @"Location",nil];
        [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Ad shared" attributes:attributes];    
    }

}

#pragma mark - Data manager delegate

- (void)postTag:(NSString *)tag finishedWithData:(NSDictionary *)data error:(NSError *)error
{
    NSNumber *adId = [self.adDataDict adId];    
    if([[SPDataManager sharedInstance] adDetailsForAdId:adId]){
        NSDictionary* adToChange = [[SPDataManager sharedInstance] adDetailsForAdId:adId];
        _adDataDict = adToChange;
    }

    
    // get rid of the overlay
    [UIView animateWithDuration:0.1 delay:1 options:0 
                     animations:^(void){
                         self.taggingProgressWrapperView.alpha = 0.0;
                     } 
                     completion:^(BOOL finished){
                         [self.taggingProgressWrapperView removeFromSuperview];
                         if (error){
                             //dismiss the progress modal, popup an error
                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Looks like there was an error voting on this ad. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                             [alert show];
                         }
                         else{
                             [self pushResultsWrapperView:YES];
                         }
                     }];

}

#pragma mark - UIWebview Delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.adVideoLoadingSpinner.hidden = YES;
    [self.adVideoButton setHidden:NO];
    [self.adVideoButton setSelected:NO];
    //show (and enable) the webview
    if(![[self adDataDict] youtubeUrl]){
        [self webView:webView didFailLoadWithError:nil];
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
            [webView setAlpha:1.0];
            [self.adVideoButton setAlpha:1.0];
    } completion:^(BOOL finished){}];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    [webView removeFromSuperview]; //ARC will collect it.
    UIAlertView *alert = [[UIAlertView  alloc] initWithTitle:@"Oops!" message:@"Looks like we can't get that video, please try again later.." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [UIView animateWithDuration:0.2 animations:^{
        [self.videoPlaceholderImageView setAlpha:0.0];
        [self.adVideoButton setAlpha:0.0];
    }];
    [self.adVideoButton setEnabled:NO];
}

//SPVoodooViewDelegate

-(void)voodooViewHit
{
    if(!self.adVideoButton.isSelected){
        [self.adVideoButton setSelected:YES];
        [self.adVideoLoadingSpinner setHidden:NO];
        [self performSelector:@selector(deselectButton) withObject:nil afterDelay:1];
        [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Video pressed"]; 
    }
}

-(void)deselectButton
{
    if(self.adVideoButton){
        [self.adVideoButton setSelected:NO];
        [self.adVideoLoadingSpinner setHidden:YES];
    }
}

- (IBAction)tagButtonTouchedDown:(id)sender {
    [self.upperLeftTagButton setEnabled:([self.upperLeftTagButton isEqual:sender])];
    [self.upperRightTagButton setEnabled:([self.upperRightTagButton isEqual:sender])];
    [self.lowerLeftTagButton setEnabled:([self.lowerLeftTagButton isEqual:sender])];
   [self.lowerRightTagButton setEnabled:([self.lowerRightTagButton isEqual:sender])];
}

- (IBAction)tagButtonTouchFinished:(id)sender {
    [self.upperLeftTagButton setEnabled:YES];
    [self.upperRightTagButton setEnabled:YES];
    [self.lowerLeftTagButton setEnabled:YES];
    [self.lowerRightTagButton setEnabled:YES];
}
@end
