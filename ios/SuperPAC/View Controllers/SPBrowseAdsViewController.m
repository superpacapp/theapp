//
//  SPBrowseAdsViewController.m
//  SuperPAC
//
//  Created by Nick Donaldson on 7/18/12.
//
//

#import "SPBrowseAdsViewController.h"
#import "SPAdDetailsViewController.h"
#import "SPBrowseAdsCell.h"
#import "UIViewFactory.h"
#import "NSDictionary+Committee.h"
#import "NSDictionary+Ad.h"
#import "NSDictionary+MyTagsSort.h"

#import "SPAnalyticsHelpers.h"
#import "LocalyticsSession.h"

#define kAdCellHeight               92
#define kAdCommitteeHeaderHeight    23
#define kAdCommitteeHeaderPaddingX  8
#define kTableFadeAnimationTime     0.15
#define kFlipAnimationTime          0.5

enum{
    SPBrowseAdsCommitteeRequestError = 50
};

enum{
    BananaPeelTypeCommitteeRequestError,
    BananaPeelTypeFilterRequestError,
    BananaPeelTypeNoFilterData,
    BananaPeelTypeNoMyTags
};

@interface SPBrowseAdsViewController ()
{

}

@property (nonatomic, strong) UITableView *myTagsTableView;

@property (nonatomic, strong) NSArray *allNonEmptyCommittees;
@property (nonatomic, strong) NSArray *filteredCommittees;
@property (nonatomic, strong) NSArray *taggedAdIds;
@property (nonatomic, strong) NSMutableSet *requestedAdIds;
@property (nonatomic, strong) NSSet* filterSettings;

@property (nonatomic, assign) BOOL myTagsActive;
@property (nonatomic, assign) BOOL filtersActive;

@property (nonatomic, strong) RZWebServiceRequest *committeesRequest;
@property (nonatomic, strong) RZWebServiceRequest *filterRequest;
@property (nonatomic, strong) NSIndexPath *cellToRefresh;

- (void)myTagsPressed;
- (void)filterPressed;
- (void)requestAllCommittees;
- (void)requestFilteredCommittees;
- (void)showCommitteesTable:(BOOL)animated;
- (void)showMyTagsTable:(BOOL)animated;
- (NSInteger)indexOfCommitteeWithId:(NSString*)committeeId;
- (NSDictionary*)buildFilterParams;
- (void)showBananaPeel:(BOOL)show forType:(NSInteger)peelType;

@end

@implementation SPBrowseAdsViewController


@synthesize committeesTableView = _committeesTableView;
@synthesize bananaPeelButton = _bananaPeelButton;
@synthesize loadingSpinner = _loadingSpinner;

@synthesize myTagsTableView = _myTagsTableView;
@synthesize allNonEmptyCommittees = _allNonEmptyCommittees;
@synthesize filteredCommittees = _filteredCommittees;
@synthesize taggedAdIds = _taggedAdIds;
@synthesize requestedAdIds = _requestedAdIds;
@synthesize filterSettings = _filterSettings;
@synthesize myTagsActive = _myTagsActive;
@synthesize filtersActive = _filtersActive;
@synthesize committeesRequest = _committeesRequest;
@synthesize filterRequest = _filterRequest;

@synthesize cellToRefresh = _cellToRefresh;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.requestedAdIds = [[NSMutableSet alloc] initWithCapacity:8];
        self.filterSettings = [NSSet set];
        _filtersActive = _myTagsActive = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"More Ads";
    
    
    // need to account for view unloading due to memory shortage
    // all properties should be set based on values of flags
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:_myTagsActive ? @"All Ads" : @"My Ads"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self 
                                                                            action:@selector(myTagsPressed)];

    if (_filtersActive){
        NSString *filterTitle = [NSString stringWithFormat:@"Filters (%d)", self.filterSettings.count];
        UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:filterTitle
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self 
                                                                        action:@selector(filterPressed)];
        
        [filterButton setBackgroundImage:[UIImage imageNamed:@"blue_button_up_variation"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.navigationItem.rightBarButtonItem = filterButton;
    }
    else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filters"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self 
                                                                                 action:@selector(filterPressed)];
    }
    
    self.myTagsTableView = [[UITableView alloc] initWithFrame:self.committeesTableView.frame style:UITableViewStylePlain];
    self.myTagsTableView.backgroundColor = [UIColor clearColor];
    self.myTagsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTagsTableView.dataSource = self;
    self.myTagsTableView.delegate = self;
    
    self.committeesTableView.sectionIndexMinimumDisplayRowCount = 50;
    self.myTagsTableView.sectionIndexMinimumDisplayRowCount = 0;

    
    // if the VC gets unloaded, need to pick up where we left off
    if (_myTagsActive){
        self.myTagsActive = YES; // this will update the buttons
        [self showMyTagsTable:NO];
    }
    else if (_filtersActive)
    {
        self.filtersActive = YES;
        [self requestFilteredCommittees];
        self.committeesTableView.alpha = 0.0f;
        [self.loadingSpinner startAnimating];
    }
    else {
        self.committeesTableView.alpha = 0.0f;
        [self.loadingSpinner startAnimating];
    }
    
    // go ahead and do this no matter what
    self.committeesRequest = [[SPDataManager sharedInstance] getCommitteesWithDelegate:self];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.cellToRefresh){
        SPBrowseAdsCell *refreshCell = (SPBrowseAdsCell*)[self tableView:self.committeesTableView cellForRowAtIndexPath:self.cellToRefresh];
        [refreshCell updateTagDisplay];
        [self.committeesTableView reloadData];
        self.cellToRefresh = nil;
    }
    
    // if we haven't gotten the committees yet and we aren't trying, try again
    // otherwise if there are committees, update the currently visible section
    if (!self.committeesRequest && !self.allNonEmptyCommittees.count)
    {
        [self.loadingSpinner startAnimating];
        self.committeesRequest = [[SPDataManager sharedInstance] getCommitteesWithDelegate:self];
    }
    
    //Localytics "Ads" (screen)
    [[LocalyticsSession sharedLocalyticsSession] tagScreen:@"Ads"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.requestedAdIds removeAllObjects];
}

- (void)viewDidUnload {
    [self setCellToRefresh:nil];
    [self setCommitteesTableView:nil];
    [self setLoadingSpinner:nil];
    [self.committeesRequest cancel];
    [self setCommitteesRequest:nil];
    [self.filterRequest cancel];
    [self setFilterRequest:nil];
    [self setBananaPeelButton:nil];
    [super viewDidUnload];
}

#pragma mark - Private Functions

- (void)showCommitteesTable:(BOOL)animated
{
    if (self.committeesTableView.superview) return;
    
    [self showBananaPeel:NO forType:0];
    
    // show the spinner if we're still loading
    if (!_filtersActive){
        if (self.committeesRequest){
            [self.loadingSpinner startAnimating];
        }
        else if (!self.allNonEmptyCommittees.count){
            [self requestAllCommittees];
        }
    }
    else {
        if (self.filterRequest){
            [self.loadingSpinner startAnimating];
        }
        else if (!self.filteredCommittees){
            [self requestFilteredCommittees];
        }
        else if (!self.filteredCommittees.count){
            [self showBananaPeel:YES forType:BananaPeelTypeNoFilterData];
        }
    }

    
    if (animated){
        [UIView transitionWithView:self.view
                          duration:kFlipAnimationTime
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [self.myTagsTableView removeFromSuperview];
                            [self.view addSubview:self.committeesTableView];
                            
                        }completion:NULL];
    }
    else{
        [self.myTagsTableView removeFromSuperview];
        [self.view addSubview:self.committeesTableView];
    }
}

- (void)showMyTagsTable:(BOOL)animated
{
    if (self.myTagsTableView.superview) return;
    
    // always stop the spinner and hide current banana peel
    [self.loadingSpinner stopAnimating];
    [self showBananaPeel:NO forType:0];

    
    // update the data (it's cheap)
    self.taggedAdIds = [[[NSUserDefaults standardUserDefaults] objectForKey:kMyTagsKey] keysSortedByValueUsingSelector:@selector(compareTagTitle:)];
    [self.myTagsTableView reloadData];
    self.myTagsTableView.alpha = self.taggedAdIds.count ? 1.0f : 0.0f;

    if (animated){        
        [UIView transitionWithView:self.view
                          duration:kFlipAnimationTime
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            [self.committeesTableView removeFromSuperview];
                            [self.view addSubview:self.myTagsTableView];
                            if (!self.taggedAdIds.count){
                                [self showBananaPeel:YES forType:BananaPeelTypeNoMyTags];
                            }
                            else{
                                [self showBananaPeel:NO forType:0];
                            }
                        }completion:NULL];
    }
    else{
        [self.committeesTableView removeFromSuperview];
        [self.view addSubview:self.myTagsTableView];
        if (!self.taggedAdIds.count){
            [self showBananaPeel:YES forType:BananaPeelTypeNoMyTags];
        }
        else{
            [self showBananaPeel:NO forType:0];
        }
    }
        
}

- (void)requestAllCommittees
{
    if (self.committeesRequest || _filtersActive)
        return;
    
    [self showBananaPeel:NO forType:0];
    self.committeesTableView.alpha = 0.0f;
    [self.loadingSpinner startAnimating];

    self.committeesRequest = [[SPDataManager sharedInstance] getCommitteesWithDelegate:self];
}

- (void)requestFilteredCommittees
{
    if (self.filterRequest || !_filtersActive)
        return;
    
    self.filteredCommittees = nil;
    [self showBananaPeel:NO forType:0];
    self.committeesTableView.alpha = 0.0f;
    [self.loadingSpinner startAnimating];
    NSDictionary *filterParams = [self buildFilterParams];
    self.filterRequest = [[SPDataManager sharedInstance] getFilteredCommitteesWithFilters:filterParams delegate:self];
}

- (NSInteger)indexOfCommitteeWithId:(NSString *)committeeId
{
    NSArray *sourceArray = _filtersActive ? self.filteredCommittees : self.allNonEmptyCommittees;
    
    return [sourceArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *committee = (NSDictionary*)obj;
        return [[committee committeeId] isEqualToString:committeeId];
    }];
}

- (NSDictionary*)buildFilterParams
{
    NSMutableDictionary *filterParams = [NSMutableDictionary dictionaryWithCapacity:3];
    
    // recent and popular
    NSString *recPop = nil;
    if ([self.filterSettings containsObject:kAdFilterTypeRecent])
    {
        if ([self.filterSettings containsObject:kAdFilterTypePopular])
            recPop = [NSString stringWithFormat:@"%@,%@",kAdFilterTypeRecent,kAdFilterTypePopular];
        else
            recPop = kAdFilterTypePopular;
    }
    else if ([self.filterSettings containsObject:kAdFilterTypePopular])
    {
        if ([self.filterSettings containsObject:kAdFilterTypeRecent])
            recPop = [NSString stringWithFormat:@"%@,%@",kAdFilterTypeRecent,kAdFilterTypePopular];
        else
            recPop = kAdFilterTypePopular;
    }
    
    if (recPop)
        [filterParams setObject:recPop forKey:kFilterType];
    
    
    // support/oppose
    NSString *supOpp = nil;
    if ([self.filterSettings containsObject:kAdFilterTypeProObama]){
        supOpp = @"support obama";
    }
    if ([self.filterSettings containsObject:kAdFilterTypeProRomney]){
        supOpp = supOpp ? [supOpp stringByAppendingString:@", support romney"] : @"support romney";
    }
    if ([self.filterSettings containsObject:kAdFilterTypeAntiObama]){
        supOpp = supOpp ? [supOpp stringByAppendingString:@", oppose obama"] : @"oppose obama";
    }
    if ([self.filterSettings containsObject:kAdFilterTypeAntiRomney]){
        supOpp = supOpp ? [supOpp stringByAppendingString:@", oppose romney"] : @"oppose romney";
    }
    
    if (supOpp)
        [filterParams setObject:supOpp forKey:kFilterSupOpp];
    
    
    // tags -- these should be exclusive
    NSString *tags = nil;
    if ([self.filterSettings containsObject:kAdFilterTypeFail]){
        tags = kAdFilterTypeFail;
    }
    else if ([self.filterSettings containsObject:kAdFilterTypeFair]){
        tags = kAdFilterTypeFair;
    }
    else if ([self.filterSettings containsObject:kAdFilterTypeFishy]){
        tags = kAdFilterTypeFishy;
    }
    else if ([self.filterSettings containsObject:kAdFilterTypeLoved]){
        tags = kAdFilterTypeLoved;
    }
    
    if (tags)
        [filterParams setObject:tags forKey:kFilterTag];
    
    return filterParams;
}

- (void)showBananaPeel:(BOOL)show forType:(NSInteger)peelType
{
    if (show){
        
        [self.bananaPeelButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
        
        if (peelType == BananaPeelTypeCommitteeRequestError){
            [self.bananaPeelButton addTarget:self action:@selector(requestAllCommittees) forControlEvents:UIControlEventTouchUpInside];
            [self.bananaPeelButton setImage:[UIImage imageNamed:@"banana_peel_connection_lost"] forState:UIControlStateNormal];
        }
        else if (peelType == BananaPeelTypeFilterRequestError){
            [self.bananaPeelButton addTarget:self action:@selector(requestFilteredCommittees) forControlEvents:UIControlEventTouchUpInside];
            [self.bananaPeelButton setImage:[UIImage imageNamed:@"banana_peel_connection_lost"] forState:UIControlStateNormal];
        }
        else if (peelType == BananaPeelTypeNoFilterData){
            [self.bananaPeelButton setImage:[UIImage imageNamed:@"banana_peel_no_filtering_selections"] forState:UIControlStateNormal];
        }
        else if (peelType == BananaPeelTypeNoMyTags){
            [self.bananaPeelButton setImage:[UIImage imageNamed:@"banana_peel_filtering"] forState:UIControlStateNormal];
        }
        
        self.bananaPeelButton.hidden = NO;
    }
    else{
        self.bananaPeelButton.hidden = YES;
    }
}

#pragma mark - Filter Functions

-(void)myTagsPressed
{
    if (_myTagsActive){
        self.myTagsActive = NO;
        [self showCommitteesTable:YES];
    }
    else{
        self.myTagsActive = YES;
        [self showMyTagsTable:YES];
    }
}

-(void)filterPressed{
    SPAdFiltersViewController *modalFilters = [[SPAdFiltersViewController alloc] initWithNibName:nil bundle:nil];
    modalFilters.filterSettings = [self.filterSettings mutableCopy];
    modalFilters.filterDelegate = self;

    self.cellToRefresh = nil; //we don't want to refresh sommething out of bounds

    [self presentModalViewController:modalFilters animated:YES];
}

- (void)updateFilters:(NSSet*)filters{
    
    if (![filters isEqualToSet:self.filterSettings]){
        
        self.filterSettings = filters;
        
        LogDebug(@"Filters: %@", filters);
        
        [self showBananaPeel:NO forType:0];
        
        //do actual filtering
        if (self.filterSettings.count)
        {
            self.filtersActive = YES;
            self.myTagsActive = NO;
            [self requestFilteredCommittees];
        }
        else
        {
            self.filtersActive = NO;
            if (self.allNonEmptyCommittees.count){
                [self.committeesTableView reloadData];
                self.committeesTableView.alpha = 1.0f;
            }
            else{
                [self requestAllCommittees];
            }
        }

        //Localytcs "Results Filtered"
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[[SPAnalyticsHelpers shared] filterValueFromFilters:[filters allObjects]], @"Filter Params", nil];
        [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Error prompt" attributes:attributes];
    }
}

#pragma mark - Properties

- (void)setMyTagsActive:(BOOL)myTagsActive
{
    _myTagsActive = myTagsActive;
    
    // disable filter button
    [self.navigationItem.rightBarButtonItem setEnabled:!_myTagsActive];
    [self.navigationItem.leftBarButtonItem setTitle:_myTagsActive ? @"All Ads" : @"My Ads"];
}

- (void)setFilterSettings:(NSSet *)filterSettings
{
    _filterSettings = filterSettings;
    BOOL hasFilters = filterSettings.count;
    NSString *buttonTitle = hasFilters ? [NSString stringWithFormat:@"Filters (%d)", self.filterSettings.count] : @"Filters";
    NSString *buttonImageName = hasFilters ? @"blue_button_up_variation" : @"navbar_button_up";
    [self.navigationItem.rightBarButtonItem setBackgroundImage:[UIImage imageNamed:buttonImageName]
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    [self.navigationItem.rightBarButtonItem setTitle:buttonTitle];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // same regardless of table
    return kAdCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // same regardless of table
    return kAdCommitteeHeaderHeight;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString *cmName = @"";
    if (tableView == _myTagsTableView){
        cmName = @"My Tags";
    }
    else if (tableView == _committeesTableView){
        if (_filtersActive)
            cmName = [[self.filteredCommittees objectAtIndex:section] committeeName];
        else
            cmName = [[self.allNonEmptyCommittees objectAtIndex:section] committeeName]; 
    }
    
    UIImage *headerImage = [UIImage imageNamed:@"category_bar_red.png"];
    UIImageView *headerImgView = [[UIImageView alloc] initWithImage:headerImage];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAdCommitteeHeaderPaddingX, 0, 320 - 2*kAdCommitteeHeaderPaddingX, kAdCommitteeHeaderHeight)];
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.4];
    headerLabel.shadowOffset = CGSizeMake(0, 1);
    headerLabel.text = cmName;
    
    [headerImgView addSubview:headerLabel];
    
    return headerImgView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // this is the same regardless of which table it is
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // still loading? do nothing
    SPBrowseAdsCell *cell = (SPBrowseAdsCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.loading || !cell.ad) return;
    
    NSDictionary *selectedAdData = cell.ad;
    if (selectedAdData){
        //Localytcs "Ad pressed"
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:@"Ads Screen", @"Location" , nil];
//        NSDictionary *reportingAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[selectedAdData adId], @"Ad id", nil]; 
        [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Ad pressed" attributes:attributes reportAttributes:nil];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.cellToRefresh = indexPath;

        SPAdDetailsViewController *adDetailsVC = [[SPAdDetailsViewController alloc] initWithNibName:nil bundle:nil];
        NSNumber *adId = [selectedAdData adId];    
        if([[SPDataManager sharedInstance] adDetailsForAdId:adId]){
            NSDictionary* adToChange = [[SPDataManager sharedInstance] adDetailsForAdId:adId];
            [adDetailsVC setAdDataDict:adToChange];;
        }else{
            adDetailsVC.adDataDict = selectedAdData;
        }
        [adDetailsVC setCommitteeDataDict: [selectedAdData committee]];
        [self.navigationController pushViewController:adDetailsVC animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _myTagsTableView){
        return 1;
    }
    else if (tableView == _committeesTableView){
        if (_filtersActive){
            return self.filteredCommittees.count;
        }
        
        return [self.allNonEmptyCommittees count];
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // yes, these two options are different
    if (tableView == _myTagsTableView){
        return self.taggedAdIds.count;
    }
    else if (tableView == _committeesTableView){
        if (_filtersActive){
            return [[[self.filteredCommittees objectAtIndex:section] committeeAdIds] count];
        }
        
        return [[[self.allNonEmptyCommittees objectAtIndex:section] committeeAdIds] count];
    }
    
    return 0;
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == _myTagsTableView)
        return nil;
    
    // A - Z
    NSMutableArray *alphabet = [NSMutableArray arrayWithCapacity:26];
    for (unichar i = 65; i<=90; i++)
    {
        [alphabet addObject:[NSString stringWithCharacters:&i length:1]];
    }
    return alphabet;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{   
    if (tableView == _myTagsTableView)
        return 0;
    
    NSString *titleLowercase = [title lowercaseString];
    NSInteger matchingSection = tableView.numberOfSections-1;
    
    // section names should already be alphabetized
    for (NSInteger s=0; s<tableView.numberOfSections; s++){
        
        // find first section that starts with a letter greater than
        NSString *cmName = _filtersActive ? [[self.filteredCommittees objectAtIndex:s] committeeName] : [[self.allNonEmptyCommittees objectAtIndex:s] committeeName];
        if (!cmName.length > 0)
            continue;
        
        NSString *firstLetter = [[cmName substringToIndex:1] lowercaseString];
        NSComparisonResult result = [titleLowercase compare:firstLetter];
        if (result == NSOrderedAscending){
            matchingSection = s > 0 ? s-1 : 0;
            break;
        }
    }
    
    // walk back to first section with this letter
    NSString *lowercaseCandidateLetter = [[[[self.allNonEmptyCommittees objectAtIndex:matchingSection] committeeName] substringToIndex:1] lowercaseString];
    while (matchingSection > 0){
        NSString *cmName = [[self.allNonEmptyCommittees objectAtIndex:matchingSection-1] committeeName];
        if ([lowercaseCandidateLetter compare:[[cmName substringToIndex:1] lowercaseString]] == NSOrderedSame){
            matchingSection--;
        }
        else break;
    }
    
    return matchingSection;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPBrowseAdsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPBrowseAdsCell"];
    if (!cell){
        cell = (SPBrowseAdsCell*)[SPBrowseAdsCell view];
    }
    else{
        // cancel request for this cell
        NSNumber *adId = [cell.adDetailRequest.userInfo objectForKey:kAdId];
        if (adId)
            [self.requestedAdIds removeObject:adId];
        
        [cell.adDetailRequest cancel];
        cell.adDetailRequest = nil;
    }
    
    // if ad is nil, it will set loading status on cell automatically
    if (tableView == _myTagsTableView){
        NSNumber *adId = [NSNumber numberWithInt:[[self.taggedAdIds objectAtIndex:indexPath.row] intValue]];
        NSDictionary *ad = [[SPDataManager sharedInstance] adDetailsForAdId:adId];
        [cell setAd:ad];
        if (!ad){
            [self.requestedAdIds addObject:adId];
            [[SPDataManager sharedInstance] getAdDetailsForAdId:adId withDelegate:self];
        }
    } else if (tableView == _committeesTableView){
        NSArray *sourceArray = _filtersActive ? self.filteredCommittees : self.allNonEmptyCommittees;
        NSNumber *adId = [[[sourceArray objectAtIndex:indexPath.section] committeeAdIds] objectAtIndex:indexPath.row];
        NSDictionary *ad = [[SPDataManager sharedInstance] adDetailsForAdId:adId];
        [cell setAd:ad];

        if (!ad && ![self.requestedAdIds containsObject:adId]){
            [self.requestedAdIds addObject:adId];
            cell.adDetailRequest = [[SPDataManager sharedInstance] getAdDetailsForAdId:adId withDelegate:self];
            }
    }
    
    return cell;
}

#pragma mark - Webservice delegate

- (void)getCommitteesFinishedWithCommittees:(NSArray *)committees error:(NSError *)error
{
    self.committeesRequest = nil;

    if (error){
        if (!_filtersActive){
            [self.loadingSpinner stopAnimating];
            [self showBananaPeel:YES forType:BananaPeelTypeCommitteeRequestError];
        }
    }
    else{
        
        NSPredicate *nonEmptyPred = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            NSDictionary *committee = (NSDictionary*)evaluatedObject;
            return [[committee committeeAdIds] count] != 0;
        }];
        NSArray *nonEmptyCommittees = [committees filteredArrayUsingPredicate:nonEmptyPred];
                        
        // pull out committee dictionaries from the key "committee"
        NSMutableArray *unsortedNonEmpty = [NSMutableArray arrayWithCapacity:nonEmptyCommittees.count];
        for (NSDictionary *committeeWrapped in nonEmptyCommittees){
            NSDictionary *committeeUnwrapped = [committeeWrapped objectForKey:kCommittee];
            if (committeeUnwrapped)
                [unsortedNonEmpty addObject:committeeUnwrapped];
        }
        
        // sort?
        NSSortDescriptor *alphaSort = [NSSortDescriptor sortDescriptorWithKey:kCommitteeName ascending:YES];
        self.allNonEmptyCommittees = [unsortedNonEmpty sortedArrayUsingDescriptors:[NSArray arrayWithObject:alphaSort]];
        
        if (!_filtersActive){
            [self.committeesTableView reloadData];
            [self.loadingSpinner stopAnimating];
            
            [UIView animateWithDuration:kTableFadeAnimationTime animations:^{
                self.committeesTableView.alpha = 1.0f;
            }];
        }
    }
}


- (void)getAdForId:(NSNumber *)adId finishedWithAd:(NSDictionary *)ad error:(NSError *)error
{
    if (error){
        if (self.isViewLoaded && self.view.window){
            // fail silently; try again in a few seconds
            double delayInSeconds = 3.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [[SPDataManager sharedInstance] getAdDetailsForAdId:adId withDelegate:self];
            });
        }
        else{
            [self.requestedAdIds removeObject:adId];
        }
    }
    else{
        
        [self.requestedAdIds removeObject:adId];
        
        if (_myTagsActive){
            NSInteger rowIndex = [self.taggedAdIds indexOfObject:[adId stringValue]];
            if (rowIndex != NSNotFound && rowIndex < [self.myTagsTableView numberOfRowsInSection:0])
            {
                SPBrowseAdsCell *cell = (SPBrowseAdsCell*)[self.myTagsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:0]];
                [cell setAd:ad];
            }
        }
        else
        {
            NSString *committeeId = [[ad committee] committeeId];
            NSInteger sectionIndex = [self indexOfCommitteeWithId:committeeId];
            if (sectionIndex != NSNotFound){
                
                NSArray *sourceArray = _filtersActive ? self.filteredCommittees : self.allNonEmptyCommittees;
                NSInteger rowIndex = [[[sourceArray objectAtIndex:sectionIndex] committeeAdIds] indexOfObject:adId];
                if (rowIndex != NSNotFound){
                    
                    NSIndexPath *cellPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
                    if ([[self.committeesTableView indexPathsForVisibleRows] containsObject:cellPath]){
                        
                        SPBrowseAdsCell *cell = (SPBrowseAdsCell*)[self.committeesTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex]];
                        [cell setAd:ad whileVisible:YES];
                    }
                }
            }
        }
    }
}

- (void)getFilteredCommitteesFinishedWithCommittees:(NSArray *)committees error:(NSError *)error
{
    self.filterRequest = nil;
    if (error)
    {
        if (_filtersActive){
            [self.loadingSpinner stopAnimating];
            [self showBananaPeel:YES forType:BananaPeelTypeFilterRequestError];
        }
    }
    else
    {
        // show new filter data
        
        NSPredicate *nonEmptyPred = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            NSDictionary *committee = (NSDictionary*)evaluatedObject;
            return [[committee committeeAdIds] count] != 0;
        }];
        NSArray *nonEmptyCommittees = [committees filteredArrayUsingPredicate:nonEmptyPred];
        
        // pull out committee dictionaries from the key "committee"
        NSMutableArray *unsortedNonEmpty = [NSMutableArray arrayWithCapacity:nonEmptyCommittees.count];
        for (NSDictionary *committeeWrapped in nonEmptyCommittees){
            NSDictionary *committeeUnwrapped = [committeeWrapped objectForKey:kCommittee];
            if (committeeUnwrapped)
                [unsortedNonEmpty addObject:committeeUnwrapped];
        }
        
        NSSortDescriptor *alphaSort = [NSSortDescriptor sortDescriptorWithKey:kCommitteeName ascending:YES];
        self.filteredCommittees = [unsortedNonEmpty sortedArrayUsingDescriptors:[NSArray arrayWithObject:alphaSort]];        
        
        if (_filtersActive){
            [self.loadingSpinner stopAnimating];
            [self.committeesTableView reloadData];
            [UIView animateWithDuration:kTableFadeAnimationTime animations:^{
                self.committeesTableView.alpha = 1.0f;
            }];
            
            if (!committees.count)
            {
                [self showBananaPeel:YES forType:BananaPeelTypeNoFilterData];
            }
        }
    }
}
@end
