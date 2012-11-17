//
//  SPAdSourcesViewController.m
//  SuperPAC
//
//  Created by Andrew Tremblay on 7/24/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//
#import "UIViewFactory.h"


#import "SPAdSourcesViewController.h"
#import "SPAdSourcesWebViewController.h"
#import "SPSourcesCell.h"
#import "SPShareController.h"
#import "NSDictionary+Ad.h"
#import "NSDictionary+Committee.h"
#import "NSDictionary+Claim.h"
#import "LocalyticsSession.h"
#import "SPAnalyticsHelpers.h"

#define kClaimHeaderHeight               30
#define kFackCheckFooterHeight           43//122

@interface SPAdSourcesViewController ()
//array of dictionries size: num claims
@property (nonatomic, strong) NSArray* claims;
//2d array, size: num claims X num source for claim (minus politifacts and factclaim)
@property (nonatomic, strong) NSArray* claimSources; //trimmed of politifact and factcheck.org links
//arrays of dictionries
@property (nonatomic, strong) NSArray* claimPoitifacts; //trimmed to just politifact links (might be null) size: num claims
@property (nonatomic, strong) NSArray* claimFactChecks; //trimmed to just factcheck.org links (might be null) size: num claims
-(void)backButtonPressed;
-(void)logClaimSourcePressedForURL:(NSString*)urlString;
@end

@implementation SPAdSourcesViewController

@synthesize tableView = _tableView;
@synthesize committeeLabel = _committeeLabel;
@synthesize adNameLabel = _adNameLabel;
@synthesize currentAd = _currentAd;

@synthesize claims = _claims;
@synthesize claimSources = _claimSources;

@synthesize claimPoitifacts = _claimPoitifacts; //trimmed to just politifact links (might be null) size: num claims
@synthesize claimFactChecks = _claimFactChecks; //trimmed to just factcheck.org links (might be null) size: num claims


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}


- (void)awakeFromNib {
    self.navigationController.hidesBottomBarWhenPushed = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"Claims";
    //Localytics "Ad Sources" (screen)
    [[LocalyticsSession sharedLocalyticsSession] tagScreen:@"Ad Sources"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sharePressed)]; 

    // Do any additional setup after loading the view from its nib.
    //load some views for their dimensions
    self.adNameLabel.text = [NSString stringWithFormat:@"Ad: %@",self.currentAd.adTitle];
    self.committeeLabel.text = self.currentAd.committee.committeeName;
    
}

- (void)viewDidUnload
{
    [self setCommitteeLabel:nil];
    [self setAdNameLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


- (void)setCurrentAd:(NSDictionary *)currentAd {
    _currentAd = currentAd;
    
    self.claims = currentAd.adClaims;
    //build the appropriate arrays
    NSMutableArray *newClaimSources = [[NSMutableArray alloc] initWithCapacity:[self.claims count]];
//    NSMutableArray *newClaimFactCheck = [[NSMutableArray alloc] initWithCapacity:[self.claims count]];
//    NSMutableArray *newClaimPolitifact = [[NSMutableArray alloc] initWithCapacity:[self.claims count]];
    for(NSDictionary *claim in self.claims){
        NSMutableArray * basicSources = [[claim  sources] mutableCopy];
//        NSInteger indexPolitifactSource = [claim politifactClaimSourceIndex];
//        NSInteger indexFactCheckSource = [claim factCheckOrgClaimSourceIndex];
        
//        // add fact check/politifact sources
//        if(indexPolitifactSource >= 0){
//            NSDictionary *politifactSource = [basicSources objectAtIndex:indexPolitifactSource];
//            [newClaimPolitifact addObject:politifactSource];
//        }else {
//            [newClaimPolitifact addObject:[NSNull null]];//none found for this claim
//        }
//        if(indexFactCheckSource >= 0){
//            NSDictionary *factCheckSource = [basicSources objectAtIndex:indexFactCheckSource];
//            [newClaimFactCheck addObject:factCheckSource];
//        }else {
//            [newClaimFactCheck addObject:[NSNull null]];//none found for this claim
//        }
//        
//        // remove these from basic claims array if they exist
//        [basicSources removeObjectsInArray:newClaimPolitifact];
//        [basicSources removeObjectsInArray:newClaimFactCheck];

        [newClaimSources addObject:basicSources];
    }
    
    self.claimSources = newClaimSources;
//    self.claimPoitifacts = newClaimPolitifact; 
//    self.claimFactChecks = newClaimFactCheck;
}

- (void)sharePressed {
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select a Method to Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email",@"SMS",@"Twitter",@"Facebook", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

//UI Interaction
-(void)backButtonPressed{
    [[self navigationController] popViewControllerAnimated:YES];
    //TODO probably localytics
}

- (CGFloat)heightForHeaderWithText:(NSString *)title {
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
    CGSize maxSize = CGSizeMake(self.tableView.frame.size.width-20, CGFLOAT_MAX);
    CGSize labelSize = [title sizeWithFont:font
                                constrainedToSize:maxSize
                                    lineBreakMode:UILineBreakModeWordWrap];
    CGFloat labelHeight = labelSize.height;
    return labelHeight;
}

#pragma mark UITableViewDelegate Methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.claims.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *titleText = [NSString stringWithFormat:@"Claim: %@",((NSDictionary *)[self.claims objectAtIndex:section]).claimTitle];
    CGFloat height = [self heightForHeaderWithText:titleText];
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(10, 5, self.tableView.frame.size.width-20, height)];
    UILabel* title = [[UILabel alloc] initWithFrame:sectionHeader.frame];
    title.numberOfLines = 0;
    title.lineBreakMode = UILineBreakModeWordWrap;
    title.text = titleText;
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
    title.textColor = kSPDarkBlueTextColor;
    [sectionHeader addSubview:title];
    return sectionHeader;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *titleText = [NSString stringWithFormat:@"Claims: %@",((NSDictionary *)[self.claims objectAtIndex:section]).claimTitle];
    return [self heightForHeaderWithText:titleText] + 10;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return kFackCheckFooterHeight;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //TODO: We Need the number of Links for each claim
    NSArray *sourcesOfSection = [self.claimSources objectAtIndex:section];
   return [sourcesOfSection count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reuseId = @"claimcell";
    SPSourcesCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if(cell == nil) {
        cell = (SPSourcesCell *)[SPSourcesCell view];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];  //for the transparency issue
        backView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = backView;
        UIView *backViewSelected = [[UIView alloc] initWithFrame:CGRectZero];  //for the transparency issue
        backViewSelected.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = backViewSelected;
    }    

//    NSDictionary *claimOfSection = ((NSDictionary *)[self.claims objectAtIndex:indexPath.section]);
    NSDictionary *claimSource = [[self.claimSources objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    NSString *imageName = nil;
    NSString *imageNameHighlighted = nil;
    
    NSArray *sourcesOfSection = [self.claimSources objectAtIndex:indexPath.section];
    if(indexPath.row == 0){  //first
        if([sourcesOfSection count] <= 1){
            //first and only
            imageName = @"table_cell_single_unselected.png";
            imageNameHighlighted = @"table_cell_single_selected.png";
        }else {
            //the first of many
            imageName = @"table_cell_top_unselected.png";
            imageNameHighlighted = @"table_cell_top_selected.png";
        }
    }else if(indexPath.row == ([sourcesOfSection count] - 1)){
        //last
        imageName = @"table_cell_bottom_unselected.png";
        imageNameHighlighted = @"table_cell_bottom_selected.png";
        
    }else{
        //all the little middles
        imageName = @"table_cell_middle_unselected.png";
        imageNameHighlighted = @"table_cell_middle_selected.png";
    }
    
    
    [cell.bgImageView setImage:[UIImage imageNamed:imageName]];
    [cell.bgImageView setHighlightedImage:[UIImage imageNamed:imageNameHighlighted]];
    [[cell sourceLabel] setText:[claimSource claimSourceName]];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    SPFactCheckView *view = (SPFactCheckView*)[SPFactCheckView view];
//    view.factCheckDelegate = self;
//    NSDictionary *claimAtSection = [self.claims objectAtIndex:section];
//    view.claimData = claimAtSection;
//    view.factCheckLabel.text = @"Fact-Checked:";
//    view.factCheckLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
//    view.factCheckLabel.textColor = kSPDarkBlueTextColor;

    [view.dividerImage setHidden:((section + 1) == [self.claims count])];
    
    return view;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *claimSource = [[self.claimSources objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if(claimSource){
        NSString *fullSourceURL = [claimSource claimSourceUrl];
        NSString *nameOfSource = [claimSource claimSourceName];
        
        if(fullSourceURL){
            [self loadURL:fullSourceURL withTitle:nameOfSource];
        }
    }
}

#pragma mark UIActionsheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //Localytics "Ad shared" 
    NSString *method = @"";
    [[SPShareController sharedInstance] setIsClaim:YES];
    switch (buttonIndex) {
        case 0: {   
            [[SPShareController sharedInstance] composeEmailForAd:self.currentAd withImage:nil];
            method = @"Email";
        }break;
        case 1: {
            [[SPShareController sharedInstance] composeMessageForAd:self.currentAd];
            method = @"SMS";
        } break;
        case 2: {
            [[SPShareController sharedInstance] composeTweetForAd:self.currentAd withImage:nil];
            method = @"Twitter";
        } break;
        case 3: {
            [[SPShareController sharedInstance] composeFacebookForAd:self.currentAd];
            method = @"Facebook";
        }
        default:
            break;
    }
    
    if(method.length > 0){
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:method, @"Method", @"Ad Sources", @"Location",nil];
        [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Ad shared" attributes:attributes];    
    }
}

-(void)loadURL:(NSString*)factURL withTitle:(NSString*)titleString {
    [self logClaimSourcePressedForURL:factURL];
    
    SPAdSourcesWebViewController *modalWebVC = [[SPAdSourcesWebViewController alloc] initWithUrl:factURL Title:titleString];
    [self presentModalViewController:modalWebVC animated:YES];


}

-(void)logClaimSourcePressedForURL:(NSString*)urlString
{
    //Localytics "Claim Source Pressed" 
    NSUInteger startIndex = 0;
    
    //http:// or https://
    NSRange httpsRange = [urlString rangeOfString:@"https://"]; 
    NSRange httpRange = [urlString rangeOfString:@"http://"]; 
    if (httpRange.location != NSNotFound) {
        startIndex = httpRange.location + httpRange.length;
    } else if (httpsRange.location != NSNotFound) {
        startIndex = httpsRange.location + httpsRange.length;
    }
    
    NSString *trimUrl = [urlString substringFromIndex:startIndex];
    NSRange endRange = [trimUrl rangeOfString:@"/"];
    NSUInteger endIndex = [trimUrl length] - 1;

    //the first / or the third /
    if(endRange.location != NSNotFound){
        endIndex = endRange.location;
    }
    
    NSString *baseUrl = [trimUrl substringToIndex:endIndex];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:baseUrl, @"Source base URL", nil];
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Claim Source pressed"attributes:attributes];// reportAttributes:reportingAttributes];    
}


@end
