//
//  Constants.m
//  SuperPAC
//
//  Created by Nick Donaldson on 7/18/12.
//
//

#import "Constants.h"

NSString *const kFirstLoadPrompt = @"firstLoadPrompt";

#pragma mark - Notifications

NSString* const kDidEnterBackgroundNotification = @"didEnterBackground";
NSString* const kWillResignActiveNotification = @"willResignActive";
NSString* const kWillEnterForegroundNotification = @"willEnterForeground";

#pragma mark - DataManager request user info keys

NSString* const kWebserviceCompletionDelegate = @"webserviceCompletionDelegate";
NSString* const kMyTagsKey = @"myTags";

#pragma mark - DataManager Method keys

NSString* const kGetCommittees = @"getCommittees";
NSString* const kGetAdsForCommittee = @"getAdsForCommittee";
NSString* const kGetAdForId = @"getAdForAdId";
NSString* const kGetAdForTunesatUUID = @"getAdForTunesatUUID";
NSString* const kGetHappeningNow = @"getHappeningNow";
NSString* const kGetMappedAds = @"getMappedAds";
NSString* const kPostAdFailed = @"postFailedAd";
NSString* const kPostFilters = @"postFilters";
NSString* const kPostAdTag = @"postAdTag";

#pragma mark - Request Keys

NSString* const kAPIAuthorizationKey = @"48650b312e74c072c5d83739121962a1";

NSString* const kFailedSide = @"s";
NSString* const kFailedCandidate = @"c";
NSString* const kFailedLat = @"lt";
NSString* const kFailedLon = @"lg";
NSString* const kFailedComments = @"cmt";

NSString* const kFilterType = @"t";
NSString* const kFilterSupOpp = @"so";
NSString* const kFilterTag = @"tg";

NSString* const kTagAdId = @"ad_id";
NSString* const kTag = @"tag";

#pragma mark - Response Keys

NSString* const kUpdatedAtTimestampFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";

NSString* const kCommittee = @"committee";
NSString* const kCommittees = @"committees";
NSString* const kCommitteeAds = @"ads";
NSString* const kCommitteeAdIds = @"ad_ids";
NSString* const kCommitteeId = @"cmte_id";
NSString* const kCommitteeName = @"committee_name";
NSString* const kCommitteeOrgType = @"org_type";
NSString* const kCommitteeTotalRaised = @"total_raised";
NSString* const kCommitteeTotalSpent = @"total_spent";
NSString* const kCommitteeSupportOppose = @"suppopp";

NSString* const kAds = @"ads";
NSString* const kAd = @"ad";
NSString* const kAdId = @"id";
NSString* const kAdTitle = @"title";
NSString* const kAdUploadDate = @"upload_date";
NSString* const kAdUpdatedAt = @"updated_at";
NSString* const kAdLatitude = @"lat";
NSString* const kAdLongitude = @"long";
NSString* const kAdVideoURL = @"url";
NSString* const kAdThumbnailURL = @"thumbnail_url";
NSString* const kAdLength = @"length";
NSString* const kAdClaims = @"claims";

NSString* const kAdTags = @"tags";
NSString* const kAdLastTag = @"last_tagged";
NSString* const kAdTagFail = @"fail";
NSString* const kAdTagFair = @"fair";
NSString* const kAdTagFishy = @"fishy";
NSString* const kAdTagLove = @"love";
NSString* const kAdTagLatitude = @"lt";
NSString* const kAdTagLongitude = @"lg";


NSString* const kClaim = @"claim";
NSString* const kClaimText = @"claim_text";
NSString* const kClaimSourceList = @"claim_sources";
NSString* const kClaimSource = @"claim_source";
NSString* const kClaimSourceName = @"source_name";
NSString* const kClaimSourceType = @"source_type";
NSString* const kClaimSourceUrl = @"source_url";

NSString* const kAdFilterTypeRecent = @"recent";
NSString* const kAdFilterTypePopular = @"popular";
NSString* const kAdFilterTypeTagged = @"tagged";
NSString* const kAdFilterTypeProObama = @"proObama";
NSString* const kAdFilterTypeProRomney = @"proRomney";
NSString* const kAdFilterTypeAntiObama = @"antiObama";
NSString* const kAdFilterTypeAntiRomney = @"antiRomney";
NSString* const kAdFilterTypeLoved = @"love";
NSString* const kAdFilterTypeFair = @"fair";
NSString* const kAdFilterTypeFishy = @"fishy";
NSString* const kAdFilterTypeFail = @"fail";
