//
//  SPHappeningNowViewController.m
//  SuperPAC
//
//  Created by Nick Donaldson on 7/18/12.
//
//

#import "SPHappeningNowViewController.h"
#import "SPTaggedAdModel.h"
#import "UIViewFactory.h"
#import "SPHappeningNowCell.h"
#import "SPCircleOverlayView.h"
#import "SPShareController.h"
#import "SPAdDetailsViewController.h"
#import "LocalyticsSession.h"
#import "NSDictionary+Ad.h"

#import <QuartzCore/QuartzCore.h>

#define kMaxMapAds              50

#define kFlipAnimationTime      0.5
#define kRefreshHalfRotateTime  0.5
#define kPinDropTime            0.5
#define kPinWiggleTime          0.3
#define kInitialWiggleAngle     M_PI/8.0
#define kRefreshAnimationKey    @"rotator"
#define kMaxZoomLevel           8

#define kUSCenterCoordinate     CLLocationCoordinate2DMake(36.15, -97.73)
#define kUSCoordinateWidth      60.0


typedef void (^ViewTransitionBlock)(void);

@interface SPHappeningNowViewController ()
{
    NSTimeInterval _lastPinAnimDelay;
    BOOL _listViewVisible;
    BOOL _refreshAnimating;
}

@property (strong, nonatomic) SPPullToRefreshView * pullToRefreshView;
@property (strong, nonatomic) RZWebServiceRequest * happeningNowRequest;
@property (strong, nonatomic) RZWebServiceRequest * mappedTagsRequest;

@property (strong, nonatomic) UIBarButtonItem *refreshButton;

- (void)listTogglePressed;
- (void)transitionToListViewAnimated:(BOOL)animated;
- (void)transitionToMapViewAnimated:(BOOL)animated;

- (void)requestHappeningNow;
- (void)requestMappedTags;

- (void)animateRefreshButton:(BOOL)animate;
- (void)wigglePin:(MKAnnotationView*)pinView;

@end

@implementation SPHappeningNowViewController
@synthesize loadingSpinner = _loadingSpinner;
@synthesize happeningNowTableView = _happeningNowTableView;
@synthesize adsMapView = _adsMapView;
@synthesize mapFrameImage = _mapFrameImage;
@synthesize allHappeningNowAds = _allHappeningNowAds;

@synthesize pullToRefreshView = _pullToRefreshView;
@synthesize happeningNowRequest = _happeningNowRequest;
@synthesize mappedTagsRequest = _mappedTagsRequest;
@synthesize refreshButton = _refreshButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _listViewVisible = NO;
        _refreshAnimating = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Happening Now";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"List"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(listTogglePressed)];
    

    self.navigationItem.rightBarButtonItem = self.refreshButton;
    
    
    self.pullToRefreshView = (SPPullToRefreshView *)[SPPullToRefreshView view];
    self.pullToRefreshView.delegate = self;
    self.pullToRefreshView.dataLoadType = self.navigationItem.title;
    self.pullToRefreshView.frame = CGRectMake(0, -kPullToRefreshHeight, self.pullToRefreshView.frame.size.width, kPullToRefreshHeight);
    [self.happeningNowTableView addSubview:self.pullToRefreshView];
    [self.pullToRefreshView updateView];
    
    [self requestHappeningNow];
    [self requestMappedTags];    
    
    [self.adsMapView setRegion:MKCoordinateRegionMake(kUSCenterCoordinate, MKCoordinateSpanMake(kUSCoordinateWidth, kUSCoordinateWidth)) animated:NO];
    
    // Need to check state if view got unloaded
    if (_listViewVisible){
        [self transitionToListViewAnimated:NO];
    }
}

- (void)viewDidUnload
{
    [self setMapFrameImage:nil];
    [self setAdsMapView:nil];
    [self setPullToRefreshView:nil];
    [self setLoadingSpinner:nil];
    [self setHappeningNowTableView:nil];
    [self setAllHappeningNowAds:nil];
    [self.happeningNowRequest cancel];
    [self setHappeningNowRequest:nil];
    [self setRefreshButton:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //Localytics "Now" (screen)
    [[LocalyticsSession sharedLocalyticsSession] tagScreen:@"Now"];
    
    if (!self.happeningNowRequest && !self.allHappeningNowAds.count){
        [self.loadingSpinner startAnimating];
        [self requestHappeningNow];
    }
    [self.happeningNowTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Hidden methods

- (UIBarButtonItem*)refreshButton
{
    if (_refreshButton == nil)
    {
        UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 30)];
        UIImage *stretchyDown = [[UIImage imageNamed:@"navbar_button_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
        UIImage *stretchyUp = [[UIImage imageNamed:@"navbar_button_up"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
        refreshButton.adjustsImageWhenDisabled = NO;
        refreshButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        refreshButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [refreshButton setBackgroundImage:stretchyDown forState:UIControlStateHighlighted];
        [refreshButton setBackgroundImage:stretchyUp forState:UIControlStateNormal];
        [refreshButton setImage:[UIImage imageNamed:@"icon-refresh"] forState:UIControlStateNormal];
        [refreshButton.imageView setContentMode:UIViewContentModeCenter];
        [refreshButton.imageView.layer setAnchorPoint:CGPointMake(0.5, 0.51)]; // minor offset so it rotates in the center
        [refreshButton addTarget:self action:@selector(requestMappedTags) forControlEvents:UIControlEventTouchUpInside];
        _refreshButton = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    }
    return _refreshButton;
}

- (void)listTogglePressed
{
    if (_listViewVisible)
    {
        [self transitionToMapViewAnimated:YES];
        _listViewVisible = NO;
    }
    else 
    {
        [self transitionToListViewAnimated:YES];
        _listViewVisible = YES;
    }
}

- (void)transitionToListViewAnimated:(BOOL)animated
{
    [self.navigationItem.leftBarButtonItem setTitle:@"Map"];
    self.navigationItem.rightBarButtonItem = nil;
    
    if (self.happeningNowRequest)
    {
        [self.loadingSpinner startAnimating];
    }
    
    // The transition actions (animatable)
    ViewTransitionBlock transitionBlock = ^{
        [self.adsMapView removeFromSuperview];
        [self.mapFrameImage removeFromSuperview];
        self.happeningNowTableView.frame = self.view.frame;
        [self.view insertSubview:_happeningNowTableView atIndex:1];
    };
    
    if (animated){
        [UIView transitionWithView:self.view
                          duration:kFlipAnimationTime
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:transitionBlock
                        completion:NULL];
    }
    else{
        transitionBlock();
    }
}

- (void)transitionToMapViewAnimated:(BOOL)animated
{
    [self.navigationItem.leftBarButtonItem setTitle:@"List"];
    self.navigationItem.rightBarButtonItem = [self refreshButton];
    
    // The transition actions (animatable)
    ViewTransitionBlock transitionBlock = ^{
        [self.happeningNowTableView removeFromSuperview];
        self.adsMapView.frame = self.view.frame;
        [self.view insertSubview:_adsMapView atIndex:1];
        [self.view addSubview:self.mapFrameImage];
    };
    
    if (animated){
        [UIView transitionWithView:self.view
                          duration:kFlipAnimationTime
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:transitionBlock
                        completion:NULL];
    }
    else{
        transitionBlock();
    }
}

- (void)requestHappeningNow 
{
    if (self.happeningNowRequest) return;
    self.happeningNowRequest = [[SPDataManager sharedInstance] getHappeningNowWithDelegate:self];
}

- (void)requestMappedTags
{
    if (self.mappedTagsRequest) return;
    self.mappedTagsRequest = [[SPDataManager sharedInstance] getMappedAdsWithDelegate:self];
    
    UIBarButtonItem *refreshButton = self.navigationItem.rightBarButtonItem;
    [refreshButton setEnabled:NO];
    
    [self animateRefreshButton:YES];
}

- (void)animateRefreshButton:(BOOL)animate
{
    // Nested recursive repeating animation... heroes in a half shell
    // Will run until the flag is set to no, then will return to start
    
    UIImageView *imageView = [(UIButton*)self.refreshButton.customView imageView];    
    if (animate){
        _refreshAnimating = YES;
        [UIView animateWithDuration:kRefreshHalfRotateTime
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             imageView.transform = CGAffineTransformMakeRotation(M_PI - 0.01);
                         } 
                         completion:^(BOOL finished) {
                             if (finished){
                                 [UIView setAnimationsEnabled:NO];
                                 imageView.transform = CGAffineTransformMakeRotation(M_PI);
                                 [UIView setAnimationsEnabled:YES];
                                 [UIView animateWithDuration:kRefreshHalfRotateTime
                                                       delay:0.0
                                                     options:UIViewAnimationOptionCurveLinear
                                                  animations:^{
                                                      imageView.transform = CGAffineTransformMakeRotation(M_PI*2.0 - 0.01);
                                                  } 
                                                  completion:^(BOOL finished) {
                                                      if (finished && _refreshAnimating){
                                                          [UIView setAnimationsEnabled:NO];
                                                          imageView.transform = CGAffineTransformIdentity;
                                                          [UIView setAnimationsEnabled:YES];
                                                          [self animateRefreshButton:YES];
                                                      }
                                                      else{
                                                           imageView.transform = CGAffineTransformIdentity;
                                                      }
                                                  }];
                             }
                         }];
    }
    else{
        _refreshAnimating = NO;
    }
}

- (void)wigglePin:(MKAnnotationView *)pinView
{
    
    // need to change anchor point and translation first
    [CATransaction begin];
    [CATransaction disableActions];
    CGFloat ratioX = 0.5f + (kMapPinCenterOffsetX/pinView.frame.size.width);
    CGFloat ratioY = 0.5f + (kMapPinCenterOffsetY/pinView.frame.size.height);
    pinView.layer.anchorPoint = CGPointMake(ratioX, ratioY);
    pinView.layer.transform = CATransform3DMakeTranslation(kMapPinCenterOffsetX, kMapPinCenterOffsetY, 0.0f);
    [CATransaction commit];
    
    // wiggle it!
    CAKeyframeAnimation *wiggleKey = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    wiggleKey.calculationMode = kCAAnimationPaced;
    wiggleKey.duration = kPinWiggleTime;
    wiggleKey.values = [NSArray arrayWithObjects:
                        [NSNumber numberWithFloat:0.0f],
                        [NSNumber numberWithFloat:kInitialWiggleAngle],
                        [NSNumber numberWithFloat:-kInitialWiggleAngle*0.66f],
                        [NSNumber numberWithFloat:kInitialWiggleAngle*0.33f],
                        [NSNumber numberWithFloat:0.0f], nil];
    wiggleKey.removedOnCompletion = YES;
    wiggleKey.fillMode = kCAFillModeForwards;
    
    [pinView.layer addAnimation:wiggleKey forKey:@"wiggler"];
}

#pragma mark - UITableViewDataSource, Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allHappeningNowAds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"happeningnowcell";
    SPHappeningNowCell *cell = (SPHappeningNowCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(nil == cell){
        cell =  (SPHappeningNowCell *)[SPHappeningNowCell view]; 
    }
    
    NSDictionary *adData = [self.allHappeningNowAds objectAtIndex:indexPath.row];
    
    //set data to most up-to-date 
    NSNumber *adId = [adData adId];    
    if([[SPDataManager sharedInstance] adDetailsForAdId:adId]){
        NSDictionary* adToChange = [[SPDataManager sharedInstance] adDetailsForAdId:adId];
        adData = adToChange;
    }

    cell.currentAd = adData;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    SPAdDetailsViewController* detailsVC = [[SPAdDetailsViewController alloc] initWithNibName:nil bundle:nil];
    NSDictionary *adData = [self.allHappeningNowAds objectAtIndex:indexPath.row];
    
    //set data to most up-to-date 
    NSNumber *adId = [adData adId];    
    if([[SPDataManager sharedInstance] adDetailsForAdId:adId]){
        NSDictionary* adToChange = [[SPDataManager sharedInstance] adDetailsForAdId:adId];
        adData = adToChange;
    }
    
    [detailsVC setAdDataDict:adData];
    [self.navigationController pushViewController:detailsVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //Localytics "Ad pressed" TODO :ad work
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:@"Now Screen", @"Location", nil];
//    NSDictionary *reportingAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[adData objectForKey:@"id"], @"Ad id", nil]; 
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Ad pressed" attributes:attributes reportAttributes:nil];
}

#pragma mark - TableView ScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pullToRefreshView scrollViewScrolled:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.pullToRefreshView scrollViewDidEndScrolling:scrollView];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.pullToRefreshView scrollViewWillBeginScrolling:scrollView];
}
#pragma mark PullToRefreshDelegate

- (void)issueRefresh {
    [self requestHappeningNow];

    //Localytics "Pull To Refresh pulled" 
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Pull To Refresh pulled"];
}


#pragma mark SPDataManager Delegate

- (void)getHappeningNowFinishedWithAds:(NSArray *)ads error:(NSError *)error {
    
    self.happeningNowRequest = nil;
    
    [self.loadingSpinner stopAnimating];
    
    if (error != nil) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Data Not Available" message:@"There was an issue retreiving data, please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [self.loadingSpinner stopAnimating];
        [self.pullToRefreshView updateFinished];
        return;
    }

    self.allHappeningNowAds = ads;
    [self.pullToRefreshView updateFinished];
    [self.happeningNowTableView reloadData];
}

- (void)getMappedAdsFinishedWithAds:(NSArray *)ads error:(NSError *)error
{
    self.mappedTagsRequest = nil;
    
    // TODO: Error handling...?
    if (error != nil) 
    {
        return;
    }
    
    [self.refreshButton setEnabled:YES];
    [self animateRefreshButton:NO];    
    
    NSMutableArray *annotationsToAdd = [NSMutableArray arrayWithCapacity:100];
    NSMutableArray *overlaysToAdd = [NSMutableArray arrayWithCapacity:100];
    
    if (ads.count > kMaxMapAds){
        ads = [ads subarrayWithRange:NSMakeRange(0, kMaxMapAds)];
    }
    
    for (NSDictionary *ad in ads)
    {
        if (![ad hasCoordinate]) continue;
        
        SPTaggedAdModel *adModel = [[SPTaggedAdModel alloc] initWithAd:ad];
        [annotationsToAdd addObject:adModel];
        
        MKCircle *circleOverlay = [MKCircle circleWithCenterCoordinate:adModel.coordinate radius:1000];
        [overlaysToAdd addObject:circleOverlay];
    }
    
    // remove all existing annotations and overlays from map
    NSArray *deadAnnotations = [[_adsMapView annotations] copy];
    if (deadAnnotations.count){
        [_adsMapView removeAnnotations:deadAnnotations];
    }
    
    NSArray *deadOverlays = [[_adsMapView overlays] copy];
    if (deadOverlays.count){
        [_adsMapView removeOverlays:deadOverlays];
    }
    
    _lastPinAnimDelay = 0.0;
    [_adsMapView addAnnotations:annotationsToAdd];
    [_adsMapView addOverlays:overlaysToAdd];
}


#pragma mark - MKMapView Delegate


- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[SPTaggedAdModel class]]){
        MKAnnotationView *anView = [(SPTaggedAdModel*)annotation annotationView];
        anView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        anView.transform = CGAffineTransformMakeTranslation(0, -400.0);
        [UIView animateWithDuration:0.7
                              delay:_lastPinAnimDelay
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             anView.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             if (finished){
                                 [self wigglePin:anView];
                             }
                         }];
        _lastPinAnimDelay += 0.05;
        return anView;
    }
    
    return nil;
}

- (MKOverlayView*)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKCircle class]])
    {
        SPCircleOverlayView *circleView = [[SPCircleOverlayView alloc] initWithCircle:(MKCircle*)overlay];
        return circleView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id<MKAnnotation> annotation = view.annotation;
    if ([annotation isKindOfClass:[SPTaggedAdModel class]])
    {
        NSDictionary *ad = [(SPTaggedAdModel*)annotation ad];
        SPAdDetailsViewController *adDetailsVC = [[SPAdDetailsViewController alloc] initWithNibName:nil bundle:nil];
        adDetailsVC.adDataDict = ad;
        [self.navigationController pushViewController:adDetailsVC animated:YES];
    }
    [mapView deselectAnnotation:annotation animated:YES];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    // reset the animation delay when adding a new set
    _lastPinAnimDelay = 0.0;
}

@end
