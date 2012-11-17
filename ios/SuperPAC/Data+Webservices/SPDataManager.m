//
//  SPDataManager.m
//  SuperPAC
//
//  Created by Nick Donaldson on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SPDataManager.h"
#import "SPImageCacheSchema.h"
#import "NSDictionary+Ad.h"
#import "NSDictionary+Committee.h"
#import "Reachability.h"

#define MAX_CONCURRENT_REQUESTS 1

static SPDataManager *_sharedDataManager;

@interface SPDataManager ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, copy) LocationCompletion locationCompletion;

@property (nonatomic, strong) NSMutableDictionary *adCacheById;

- (void)addHeadersToRequest:(RZWebServiceRequest*)request;

// webservice completion handlers
- (void)getCommitteesSucceeded:(id)data request:(RZWebServiceRequest*)request;
- (void)getCommitteesFailed:(NSError*)error request:(RZWebServiceRequest*)request;
- (void)getAdsForCommitteeSucceeded:(id)data request:(RZWebServiceRequest*)request;
- (void)getAdsForCommitteeFailed:(NSError*)error request:(RZWebServiceRequest*)request;
- (void)getAdForIdSucceeded:(id)data request:(RZWebServiceRequest*)request;
- (void)getAdForIdFailed:(NSError*)error request:(RZWebServiceRequest*)request;
- (void)getAdForTunesatUUIDSucceeded:(id)data request:(RZWebServiceRequest*)request;
- (void)getAdForTunesatUUIDFailed:(NSError*)error request:(RZWebServiceRequest*)request;
- (void)getHappeningNowSucceeded:(id)data request:(RZWebServiceRequest *)request;
- (void)getHappeningNowFailed:(NSError *)error request:(RZWebServiceRequest *)request;
- (void)getMappedAdsSucceeded:(id)data request:(RZWebServiceRequest *)request;
- (void)getMappedAdsFailed:(NSError *)error request:(RZWebServiceRequest *)request;
- (void)postFailedAdSucceeded:(id)data request:(RZWebServiceRequest *)request;
- (void)postFailedAdFailed:(NSError *)error request:(RZWebServiceRequest *)request;
- (void)postFiltersSucceeded:(id)data request:(RZWebServiceRequest *)request;
- (void)postFiltersFailed:(NSError *)error request:(RZWebServiceRequest *)request;
- (void)postAdTagSucceeded:(id)data request:(RZWebServiceRequest*)request;
- (void)postAdTagFailed:(NSError*)error request:(RZWebServiceRequest*)request;


@end

@implementation SPDataManager

@synthesize webserviceManager = _webserviceManager;
@synthesize imageFileManager = _imageFileManager;
@synthesize allCommittees = _allCommittees;
@synthesize locationManager = _locationManager;
@synthesize adCacheById = _adCacheById;
@synthesize currentLocation = _currentLocation;
@synthesize locationCompletion = _locationCompletion;

#pragma mark - Init

+(SPDataManager*)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataManager = [[SPDataManager alloc] init];
    });

    return _sharedDataManager;
}

-(id)init
{
    if (self = [super init])
    {
        NSString *callsPath = [[NSBundle mainBundle] pathForResource:@"SuperPACWebservices" ofType:@"plist"];
        _webserviceManager = [[RZWebServiceManager alloc] initWithCallsPath:callsPath];
        _webserviceManager.defaultHost = API_ENDPOINT;
        [_webserviceManager setMaximumConcurrentRequests:MAX_CONCURRENT_REQUESTS];
        
        SPImageCacheSchema *cacheSchema = [[SPImageCacheSchema alloc] init];
        cacheSchema.downloadCacheDirectory = [RZFileManager defaultDownloadCacheURL];
        
        _imageFileManager = [[RZFileManager alloc] init];
        _imageFileManager.webManager = _webserviceManager;
        _imageFileManager.cacheSchema = cacheSchema;
        
        self.adCacheById = [NSMutableDictionary dictionaryWithCapacity:256];
    }
    return self;
}

- (void)getCurrentLocationWithCompletionBlock:(LocationCompletion)completion
{
    self.locationCompletion = completion;
    
    if (!_locationManager){
        // Don't need very high accuracy for this - will be used for ad tag coordinates
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        self.locationManager.distanceFilter = 3000;
        self.locationManager.delegate = self;        
    }
    
    [self.locationManager startUpdatingLocation];
}


#pragma mark - Data

- (NSDictionary*)adDetailsForAdId:(NSNumber*)adId
{
    if (adId){
        return [self.adCacheById objectForKey:adId];
    }
    return nil;
}

- (NSString *)tagForAdId:(NSNumber *)adId {
    if (adId != nil) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary* tags = [defaults objectForKey:kMyTagsKey];
        if (!tags) {
            return nil;
        }
        NSDictionary* tagData = [tags objectForKey:[NSString stringWithFormat:@"%d",[adId intValue]]];
        return [tagData objectForKey:kTag];
    }
    return nil;
}

- (void)setTag:(NSString *)tag forAdId:(NSNumber *)adId adTitle:(NSString *)adTitle{
    if (tag != nil && tag.length > 0 && adId != nil) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary* myTags = [[NSMutableDictionary alloc] initWithDictionary:[defaults objectForKey:kMyTagsKey]];
        NSMutableDictionary *tagData = [NSMutableDictionary dictionaryWithObjectsAndKeys:tag, kTag, nil];
        if (adTitle)
            [tagData setObject:adTitle forKey:kAdTitle];
        [myTags setObject:tagData forKey:[NSString stringWithFormat:@"%d",[adId intValue]]];
        [defaults setObject:myTags forKey:kMyTagsKey];
        [defaults synchronize];
    }
}



- (void)clearCachedData
{
    [self.adCacheById removeAllObjects];
}

#pragma mark - Webservice Calls

- (void)addHeadersToRequest:(RZWebServiceRequest *)request
{
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithCapacity:2];
    [headers setObject:[NSString stringWithFormat:@"Token %@",kAPIAuthorizationKey] forKey:@"Authorization"];
    [headers setObject:@"application/json" forKey:@"Accept"];
    
    request.headers = headers;
}

- (RZWebServiceRequest*)getCommitteesWithDelegate:(id<SPDataManagerDelegate>)delegate
{    
    LogDebug(@"Requesting Committees...");
    
    RZWebServiceRequest *request = [self.webserviceManager makeRequestWithKey:kGetCommittees
                                                                    andTarget:self
                                                                andParameters:nil
                                                                      enqueue:NO];
    
    if (delegate)
    	request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:delegate, kWebserviceCompletionDelegate, nil];
    
    [self addHeadersToRequest:request];
    [self.webserviceManager enqueueRequest:request];
    return request;
}

- (RZWebServiceRequest*)getAdsForCommittee:(NSString*)committeeId withDelegate:(id<SPDataManagerDelegate>)delegate
{
    LogDebug(@"Requesting ads for committee %@...", committeeId);
    
    if (!committeeId){
        LogError(@"No committee ID Provided");
        return nil;
    }

    RZWebServiceRequest *request = [self.webserviceManager makeRequestWithTarget:self
                                                                   andParameters:nil
                                                                         enqueue:NO
                                                                    andFormatKey:kGetAdsForCommittee, committeeId];
    
    if (delegate)
        request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:delegate, kWebserviceCompletionDelegate, nil];
    
    [self addHeadersToRequest:request];
    [self.webserviceManager enqueueRequest:request];
    return request;
}

- (RZWebServiceRequest*)getAdDetailsForAdId:(NSNumber*)adId withDelegate:(id<SPDataManagerDelegate>)delegate
{
    LogDebug(@"Requesting ad details for Id: %@", adId);
    
    if (!adId){
        LogError(@"No Ad ID Provided");
        return nil;
    }
    
    RZWebServiceRequest *request = [self.webserviceManager makeRequestWithTarget:self
                                                                   andParameters:nil
                                                                         enqueue:NO
                                                                    andFormatKey:kGetAdForId, adId];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:adId forKey:kAdId];
    
    if (delegate)
        [userInfo setObject:delegate forKey:kWebserviceCompletionDelegate];
    
    request.userInfo = userInfo;
    
    [self addHeadersToRequest:request];
    [self.webserviceManager enqueueRequest:request];
    return request;
}

- (RZWebServiceRequest*)getAdForTunesatUUID:(NSString*)uuid withDelegate:(id<SPDataManagerDelegate>)delegate
{
    LogDebug(@"Requesting ad details for tunesat UUID: %@", uuid);
    
    if (!uuid){
        LogError(@"No UUID provided");
        return nil;
    }
    
    RZWebServiceRequest *request = [self.webserviceManager makeRequestWithTarget:self
                                                                   andParameters:nil
                                                                         enqueue:NO
                                                                    andFormatKey:kGetAdForTunesatUUID, uuid];
    
    if (delegate)
        request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:delegate, kWebserviceCompletionDelegate, nil];
    
    [self addHeadersToRequest:request];
    [self.webserviceManager enqueueRequest:request];
    return request;
}

- (RZWebServiceRequest*)getHappeningNowWithDelegate:(id<SPDataManagerDelegate>)delegate {
    LogDebug(@"Requesting HappeningNow");
    RZWebServiceRequest *request = [self.webserviceManager makeRequestWithKey:kGetHappeningNow 
                                                                    andTarget:self 
                                                                andParameters:nil 
                                                                      enqueue:NO];
    if (delegate)
        request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:delegate, kWebserviceCompletionDelegate, nil];
    
    [self addHeadersToRequest:request];
    [self.webserviceManager enqueueRequest:request];
    return request;
    
}

- (RZWebServiceRequest*)getMappedAdsWithDelegate:(id<SPDataManagerDelegate>)delegate
{
    LogDebug(@"Reqeusting Mapped Ads");
    RZWebServiceRequest *request = [self.webserviceManager makeRequestWithKey:kGetMappedAds
                                                                    andTarget:self
                                                                andParameters:nil
                                                                      enqueue:NO];
    
    if (delegate)
        request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:delegate, kWebserviceCompletionDelegate, nil];
    
    [self addHeadersToRequest:request];
    [self.webserviceManager enqueueRequest:request];
    return request;
}

- (RZWebServiceRequest*)postAdFailedWithInfo:(NSDictionary*)failedParams delegate:(id<SPDataManagerDelegate>)delegate
{
    
    LogDebug(@"Posting Failed Response with Parameters:%@",failedParams);
    RZWebServiceRequest *request = [self.webserviceManager makeRequestWithKey:kPostAdFailed andTarget:self andParameters:failedParams enqueue:NO];
    
    if (delegate)
        request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:delegate, kWebserviceCompletionDelegate, nil];

    [self addHeadersToRequest:request];
    [self.webserviceManager enqueueRequest:request];
    return request;
    
}

- (RZWebServiceRequest*)getFilteredCommitteesWithFilters:(NSDictionary *)filters delegate:(id<SPDataManagerDelegate>)delegate
{
    LogDebug(@"Requesting filtered committees with filters: %@", filters);
    RZWebServiceRequest *request = [self.webserviceManager makeRequestWithKey:kPostFilters andTarget:self andParameters:filters enqueue:NO];
    
    if (delegate)
        request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:delegate, kWebserviceCompletionDelegate, nil];
    
    [self addHeadersToRequest:request];
    [self.webserviceManager enqueueRequest:request];
    return request;
}

- (RZWebServiceRequest*)postTag:(NSString*)tag forAdId:(NSNumber*)adId delegate:(id<SPDataManagerDelegate>)delegate
{
    LogDebug(@"Posting tag %@ for ad %@", tag, adId);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:tag, kTag, nil];
    
    if (self.currentLocation != nil){
        CLLocationCoordinate2D coord = self.currentLocation.coordinate;
        [parameters setObject:[NSNumber numberWithDouble:coord.latitude] forKey:kAdTagLatitude];
        [parameters setObject:[NSNumber numberWithDouble:coord.longitude] forKey:kAdTagLongitude];
    }
    
    RZWebServiceRequest *request = [self.webserviceManager makeRequestWithTarget:self
                                                                   andParameters:parameters
                                                                         enqueue:NO 
                                                                    andFormatKey:kPostAdTag, adId];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:tag, kTag, adId, kTagAdId, nil];
    if (delegate)
        [userInfo setObject:delegate forKey:kWebserviceCompletionDelegate];
    
    request.userInfo = userInfo;
    
    [self addHeadersToRequest:request];
    [self.webserviceManager enqueueRequest:request];
    return request;
}

#pragma mark - Webservice Completion handlers

- (void)getCommitteesSucceeded:(id)data request:(RZWebServiceRequest *)request
{
    LogDebug(@"Get Committees succeded with data:\n%@", data);
    
    // save the committees list
    if ([data isKindOfClass:[NSDictionary class]]){
        _allCommittees = (NSArray*)[data objectForKey:kCommittees];
    }
    
    id<SPDataManagerDelegate> delegate = [request.userInfo objectForKey:kWebserviceCompletionDelegate];
    if ([delegate respondsToSelector:@selector(getCommitteesFinishedWithCommittees:error:)])
    {
        [delegate getCommitteesFinishedWithCommittees:_allCommittees error:nil];
    }
}

- (void)getCommitteesFailed:(NSError*)error request:(RZWebServiceRequest *)request
{
    LogError(@"Get committees failed with error:\n%@", error);
    id<SPDataManagerDelegate> delegate = [request.userInfo objectForKey:kWebserviceCompletionDelegate];
    if ([delegate respondsToSelector:@selector(getCommitteesFinishedWithCommittees:error:)])
    {
        [delegate getCommitteesFinishedWithCommittees:nil error:error];
    }
}

- (void)getAdsForCommitteeSucceeded:(id)data request:(RZWebServiceRequest*)request
{
    LogDebug(@"Get ads for committee succeded with data:\n%@", data);
    
    if ([data isKindOfClass:[NSArray class]])
    {
        NSDictionary *committeeDetails = [[data lastObject] objectForKey:kCommittee];
        NSString *committeeId = [request.url lastPathComponent];
        NSArray *ads = [committeeDetails objectForKey:kCommitteeAds];
        
        // only the committee info
        NSMutableDictionary *committeeForAds = [committeeDetails mutableCopy];
        [committeeForAds removeObjectForKey:kAds];
        
        NSMutableArray *adsToRet = [NSMutableArray arrayWithCapacity:[ads count]];
        
        if (ads && committeeId){
        
            // key each ad in the array by its server-assigned index
            for (NSDictionary *ad in ads)
            {
                NSNumber *adId = [ad adId];
                if (adId){
                    NSDictionary *adMutable = [[ad objectForKey:kAd] mutableCopy];
                    [adMutable setValue:committeeForAds forKey:kCommittee];
                    [self.adCacheById setObject:adMutable forKey:adId];
                    
                    [adsToRet addObject:adMutable];
                }
            }
            
            id<SPDataManagerDelegate> delegate = [request.userInfo objectForKey:kWebserviceCompletionDelegate];
            if ([delegate respondsToSelector:@selector(getAdsForCommittee:finishedWithAds:error:)])
            {
                [delegate getAdsForCommittee:committeeId finishedWithAds:adsToRet error:nil];
            }
        }
    }
}

- (void)getAdsForCommitteeFailed:(NSError*)error request:(RZWebServiceRequest*)request
{
    NSString *committeeId = [request.url lastPathComponent];
    LogError(@"Get ad for committee ID %@ failed with error:\n%@", committeeId, error);
    id<SPDataManagerDelegate> delegate = [request.userInfo objectForKey:kWebserviceCompletionDelegate];
    if ([delegate respondsToSelector:@selector(getAdsForCommittee:finishedWithAds:error:)])
    {
        [delegate getAdsForCommittee:committeeId finishedWithAds:nil error:error];
    }
}

- (void)getAdForIdSucceeded:(id)data request:(RZWebServiceRequest*)request
{
    //LogDebug(@"Get ads for ad Id succeeded with data:\n%@", data);
    
    // save to cache by id
    NSNumber *adId = [data adId];
    if (adId)
    {
        [self.adCacheById setObject:(NSDictionary*)data forKey:adId];
    }

    id<SPDataManagerDelegate> delegate = [request.userInfo objectForKey:kWebserviceCompletionDelegate];
    if ([delegate respondsToSelector:@selector(getAdForId:finishedWithAd:error:)])
    {
        [delegate getAdForId:adId finishedWithAd:(NSDictionary*)data error:nil];
    }

}

- (void)getAdForIdFailed:(NSError*)error request:(RZWebServiceRequest*)request
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *adId = [formatter numberFromString:[request.url lastPathComponent]];
    
    LogError(@"Get ad for ad ID %@ failed with error: %@", adId, error);
    id<SPDataManagerDelegate> delegate = [request.userInfo objectForKey:kWebserviceCompletionDelegate];
    if ([delegate respondsToSelector:@selector(getAdForId:finishedWithAd:error:)])
    {
        [delegate getAdForId:adId finishedWithAd:nil error:error];
    }
}

- (void)getAdForTunesatUUIDSucceeded:(id)data request:(RZWebServiceRequest*)request
{
    LogDebug(@"Get ads for tunesat UUID succeeded with data:\n%@", data);

    // save to cache by id
    NSNumber *adId = [data adId];
    if (adId)
    {
        [self.adCacheById setObject:(NSDictionary*)data forKey:adId];
    }

    id<SPDataManagerDelegate> delegate = [request.userInfo objectForKey:kWebserviceCompletionDelegate];
    if ([delegate respondsToSelector:@selector(getAdForTunesatUUIDFinishedWithAd:error:)])
    {
        [delegate getAdForTunesatUUIDFinishedWithAd:(NSDictionary*)data error:nil];
    }

}

- (void)getAdForTunesatUUIDFailed:(NSError*)error request:(RZWebServiceRequest*)request
{
    LogError(@"Get ad for tunesat UUID Failed with error:\n%@",error);
    id<SPDataManagerDelegate> delegate = [request.userInfo objectForKey:kWebserviceCompletionDelegate];
    if ([delegate respondsToSelector:@selector(getAdForTunesatUUIDFinishedWithAd:error:)])
    {
        [delegate getAdForTunesatUUIDFinishedWithAd:nil error:error];
    }

}

- (void)getHappeningNowSucceeded:(id)data request:(RZWebServiceRequest *)request {
    LogDebug(@"Get Happening Now succeeded with data:\n%@", data);

    NSArray *ads = [data objectForKey:kAds];
    
    // cache each ad
    for (NSDictionary *ad in ads){
        NSNumber *adId = [ad adId];
        if (adId)
            [self.adCacheById setObject:ad forKey:adId];
    }
    
    id<SPDataManagerDelegate> delegate = [request.userInfo objectForKey:kWebserviceCompletionDelegate];
    if ([delegate respondsToSelector:@selector(getHappeningNowFinishedWithAds:error:)])
    {
        [delegate getHappeningNowFinishedWithAds:ads error:nil];
    }
}

- (void)getHappeningNowFailed:(NSError *)error request:(RZWebServiceRequest *)request {
    
    LogError(@"Get happening now failed with error:\n%@", error);
    id<SPDataManagerDelegate> delegate = [request.userInfo objectForKey:kWebserviceCompletionDelegate];
    if ([delegate respondsToSelector:@selector(getHappeningNowFinishedWithAds:error:)])
    {
        [delegate getHappeningNowFinishedWithAds:nil error:error];
    }
}

- (void)getMappedAdsSucceeded:(id)data request:(RZWebServiceRequest *)request
{
    LogDebug(@"Get mapped ads succeded with data:\n%@", data);
    
    NSArray *ads = [data objectForKey:kAds];
    
    // cache each ad
    for (NSDictionary *ad in ads){
        NSNumber *adId = [ad adId];
        if (adId)
            [self.adCacheById setObject:ad forKey:adId];
    }
    
    id<SPDataManagerDelegate> delegate = [request.userInfo objectForKey:kWebserviceCompletionDelegate];
    if ([delegate respondsToSelector:@selector(getMappedAdsFinishedWithAds:error:)])
    {
        [delegate getMappedAdsFinishedWithAds:ads error:nil];
    }
}

- (void)getMappedAdsFailed:(NSError *)error request:(RZWebServiceRequest *)request
{
    LogError(@"Get mapped ads failed with error: %@", [error localizedDescription]);
    id<SPDataManagerDelegate> delegate = [request.userInfo objectForKey:kWebserviceCompletionDelegate];
    if ([delegate respondsToSelector:@selector(getMappedAdsFinishedWithAds:error:)])
        [delegate getMappedAdsFinishedWithAds:nil error:error];
    
}

- (void)postFailedAdSucceeded:(id)data request:(RZWebServiceRequest *)request {
    LogDebug(@"Post failed ad succeeded with data:\n%@", data);
    id<SPDataManagerDelegate> delegate = [request.userInfo objectForKey:kWebserviceCompletionDelegate];
    if ([delegate respondsToSelector:@selector(postAdFailedFinishedWithResponse:error:)])
    {
        [delegate postAdFailedFinishedWithResponse:data error:nil];
    }
    
}
- (void)postFailedAdFailed:(NSError *)error request:(RZWebServiceRequest *)request{
    LogError(@"Post failed Ad Failed with error:\n%@",error);
    id<SPDataManagerDelegate> delegate = [request.userInfo objectForKey:kWebserviceCompletionDelegate];
    if ([delegate respondsToSelector:@selector(postAdFailedFinishedWithResponse:error:)])
    {
        [delegate postAdFailedFinishedWithResponse:nil error:error];
    }
    
}

- (void)postFiltersSucceeded:(id)data request:(RZWebServiceRequest *)request
{
    LogDebug(@"Filtered committees succeeded with data:\n%@", data);
    
    // add the ads to the cache

    
    id<SPDataManagerDelegate> delegate = [request.userInfo objectForKey:kWebserviceCompletionDelegate];
    if ([delegate respondsToSelector:@selector(getFilteredCommitteesFinishedWithCommittees:error:)])
    {
        [delegate getFilteredCommitteesFinishedWithCommittees:data error:nil];
    }
}

- (void)postFiltersFailed:(NSError *)error request:(RZWebServiceRequest *)request
{
    LogError(@"Filtered committees Failed with error:\n%@",error);
    id<SPDataManagerDelegate> delegate = [request.userInfo objectForKey:kWebserviceCompletionDelegate];
    if ([delegate respondsToSelector:@selector(getFilteredCommitteesFinishedWithCommittees:error:)])
    {
        [delegate getFilteredCommitteesFinishedWithCommittees:nil error:error];
    }
}

- (void)postAdTagSucceeded:(id)data request:(RZWebServiceRequest*)request
{
    LogDebug(@"Post ad tag succeeded with data:\n%@", data);
    
    NSString *tag = [request.userInfo objectForKey:kTag];
    NSNumber *adId = [request.userInfo objectForKey:kTagAdId];
        
    NSDictionary *newTags = [[data objectForKey:kAd] objectForKey:kAdTags];
    NSMutableDictionary* adToChange = [[self.adCacheById objectForKey:adId] mutableCopy];
    
    if([adToChange objectForKey:kAdTags]){
        [adToChange setObject:newTags forKey:kAdTags];
    }else {
        NSMutableDictionary *innerAd = [[adToChange objectForKey:kAd] mutableCopy];
        [innerAd setObject:newTags forKey:kAdTags];
        [adToChange setObject:innerAd forKey:kAd];
    }
    [self.adCacheById setObject:adToChange forKey:adId];
    
    NSDictionary *ad = [self adDetailsForAdId:adId];
    NSString *adTitle = [ad adTitle];
    
    //log our personal vote
    if (tag && adId)
        [self setTag:tag forAdId:adId adTitle:adTitle];

    
    id<SPDataManagerDelegate> delegate = [request.userInfo objectForKey:kWebserviceCompletionDelegate];
    if ([delegate respondsToSelector:@selector(postTag:finishedWithData:error:)])
    {
        [delegate postTag:tag finishedWithData:data error:nil];
    }
}

- (void)postAdTagFailed:(NSError*)error request:(RZWebServiceRequest*)request
{
    LogError(@"Post ad tag failed with error: %@", error);
    id<SPDataManagerDelegate> delegate = [request.userInfo objectForKey:kWebserviceCompletionDelegate];
    if ([delegate respondsToSelector:@selector(postTag:finishedWithData:error:)])
    {
        [delegate postTag:nil finishedWithData:nil error:error];
    }
}

#pragma mark - Location delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    _currentLocation = newLocation;
    if (_locationCompletion){
        _locationCompletion(newLocation);
        self.locationCompletion = nil;
    }
    [manager stopUpdatingLocation];
    LogDebug(@"Updated to location: %@", newLocation);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    _currentLocation = nil;
    if (_locationCompletion){
        _locationCompletion(nil);
        self.locationCompletion = nil;
    }
    [manager stopUpdatingLocation];
}
#pragma mark - Reachability Methods

-(BOOL)networkReachable
{
    Reachability *internetReachable = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            LogError(@"The internet is down.");
            return NO;
            break;
        }
        case ReachableViaWiFi:
        {
            LogDebug(@"The internet is working via WIFI.");
            return YES;
            break;
        }
        case ReachableViaWWAN:
        {
            LogDebug(@"The internet is working via WWAN.");
            return YES;
            break;
        }
    }
}
@end
