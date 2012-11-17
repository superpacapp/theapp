//
//  SPDataManager.h
//  SuperPAC
//
//  Created by Nick Donaldson on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "RZWebServiceManager.h"
#import "RZFileManager.h"

typedef void (^LocationCompletion)(CLLocation *location);

@protocol SPDataManagerDelegate <NSObject>

@optional
- (void)getCommitteesFinishedWithCommittees:(NSArray*)committees error:(NSError*)error;
- (void)getAdsForCommittee:(NSString*)committeeId finishedWithAds:(NSArray*)ads error:(NSError*)error;
- (void)getAdForId:(NSNumber*)adId finishedWithAd:(NSDictionary*)ad error:(NSError*)error;
- (void)getAdForTunesatUUIDFinishedWithAd:(NSDictionary*)ad error:(NSError*)error;
- (void)getHappeningNowFinishedWithAds:(NSArray*)ads error:(NSError*)error;
- (void)getMappedAdsFinishedWithAds:(NSArray*)ads error:(NSError*)error;
- (void)postAdFailedFinishedWithResponse:(NSDictionary *)dict error:(NSError *)error;
- (void)getFilteredCommitteesFinishedWithCommittees:(NSArray*)committees error:(NSError*)error;
- (void)postTag:(NSString*)tag finishedWithData:(NSDictionary*)data error:(NSError*)error;

@end

@interface SPDataManager : NSObject <CLLocationManagerDelegate>

+(SPDataManager*)sharedInstance;

// Location ====================================

- (void)getCurrentLocationWithCompletionBlock:(LocationCompletion)completion;

// Data collections and cached data ===================================
@property (nonatomic, readonly, strong) NSArray *allCommittees;

// These methods try to get details from the local cache.
// If they return nil, the requested info will need to be fetched from the API

// get ad details by ad id
- (NSDictionary*)adDetailsForAdId:(NSNumber*)adId;

- (void)clearCachedData;

- (NSString *)tagForAdId:(NSNumber *)adId;
- (void)setTag:(NSString *)tag forAdId:(NSNumber *)adId adTitle:(NSString*)adTitle;

// Webservices ====================================

@property (nonatomic, readonly, strong) RZWebServiceManager *webserviceManager;
@property (nonatomic, readonly, strong) RZFileManager *imageFileManager;

- (RZWebServiceRequest*)getCommitteesWithDelegate:(id<SPDataManagerDelegate>)delegate;

// call this to request ads that we don't have in the cache, use the response to fill the cells if they are visible
- (RZWebServiceRequest*)getAdsForCommittee:(NSString*)committeeId withDelegate:(id<SPDataManagerDelegate>)delegate;

- (RZWebServiceRequest*)getAdDetailsForAdId:(NSNumber*)adId withDelegate:(id<SPDataManagerDelegate>)delegate;

- (RZWebServiceRequest*)getAdForTunesatUUID:(NSString*)uuid withDelegate:(id<SPDataManagerDelegate>)delegate;

- (RZWebServiceRequest*)getHappeningNowWithDelegate:(id<SPDataManagerDelegate>)delegate;

- (RZWebServiceRequest*)getMappedAdsWithDelegate:(id<SPDataManagerDelegate>)delegate;

- (RZWebServiceRequest*)postAdFailedWithInfo:(NSDictionary*)failedParams delegate:(id<SPDataManagerDelegate>)delegate;

- (RZWebServiceRequest*)getFilteredCommitteesWithFilters:(NSDictionary*)filters delegate:(id<SPDataManagerDelegate>)delegate;

- (RZWebServiceRequest*)postTag:(NSString*)tag forAdId:(NSNumber*)adId delegate:(id<SPDataManagerDelegate>)delegate;

//Internet connectivity check
-(BOOL)networkReachable;

@end
