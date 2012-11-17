//
//  Constants.h
//  SuperPAC
//
//  Created by Nick Donaldson on 7/18/12.
//
//

#if API_ENDPOINT_DEV
    #define API_ENDPOINT    @"http://superpacapp-staging.herokuapp.com"
#elif API_ENDPOINT_PRODUCTION
    #define API_ENDPOINT    @"http://superpacapp.org"
#endif

#define FACEBOOK_APPID  @"290335984314887"
#define ITUNES_URL      @"http://superpacapp.org/download"

extern NSString* const kFirstLoadPrompt;

#pragma mark - Notifications

extern NSString* const kDidEnterBackgroundNotification;
extern NSString* const kWillResignActiveNotification;
extern NSString* const kWillEnterForegroundNotification;

#pragma mark - DataManager request user info keys

extern NSString* const kWebserviceCompletionDelegate;
extern NSString* const kMyTagsKey;

#pragma mark - DataManager Method constants

extern NSString* const kGetCommittees;
extern NSString* const kGetAdsForCommittee;
extern NSString* const kGetAdForId;
extern NSString* const kGetAdForTunesatUUID;
extern NSString* const kGetHappeningNow;
extern NSString* const kGetMappedAds;
extern NSString* const kPostAdFailed;
extern NSString* const kPostFilters;
extern NSString* const kPostAdTag;

#pragma mark - Request Keys

extern NSString* const kAPIAuthorizationKey;

extern NSString* const kFailedSide;
extern NSString* const kFailedCandidate;
extern NSString* const kFailedLat;
extern NSString* const kFailedLon;
extern NSString* const kFailedComments;

extern NSString* const kFilterType;
extern NSString* const kFilterSupOpp;
extern NSString* const kFilterTag;

extern NSString* const kTagAdId;
extern NSString* const kTag;

#pragma mark - Response keys

extern NSString* const kUpdatedAtTimestampFormat;

extern NSString* const kCommittee;
extern NSString* const kCommittees;
extern NSString* const kCommitteeAdIds;
extern NSString* const kCommitteeAds;
extern NSString* const kCommitteeId;
extern NSString* const kCommitteeName;
extern NSString* const kCommitteeOrgType;
extern NSString* const kCommitteeTotalRaised;
extern NSString* const kCommitteeTotalSpent;
extern NSString* const kCommitteeSupportOppose;

extern NSString* const kAd;
extern NSString* const kAds;
extern NSString* const kAdId;
extern NSString* const kAdTitle;
extern NSString* const kAdUploadDate;
extern NSString* const kAdUpdatedAt;
extern NSString* const kAdLatitude;
extern NSString* const kAdLongitude;
extern NSString* const kAdVideoURL;
extern NSString* const kAdThumbnailURL;
extern NSString* const kAdLength;
extern NSString* const kAdUploadDate;
extern NSString* const kAdClaims;

extern NSString* const kAdTags;
extern NSString* const kAdLastTag;
extern NSString* const kAdTagFail;
extern NSString* const kAdTagFair;
extern NSString* const kAdTagFishy;
extern NSString* const kAdTagLove;
extern NSString* const kAdTagLatitude;
extern NSString* const kAdTagLongitude;

extern NSString* const kClaim;
extern NSString* const kClaimText;
extern NSString* const kClaimSourceList;
extern NSString* const kClaimSource;
extern NSString* const kClaimSourceName;
extern NSString* const kClaimSourceType;
extern NSString* const kClaimSourceUrl;

extern NSString* const kAdFilterTypeRecent;
extern NSString* const kAdFilterTypePopular;
extern NSString* const kAdFilterTypeTagged;
extern NSString* const kAdFilterTypeProObama;
extern NSString* const kAdFilterTypeProRomney;
extern NSString* const kAdFilterTypeAntiObama;
extern NSString* const kAdFilterTypeAntiRomney;
extern NSString* const kAdFilterTypeLoved;
extern NSString* const kAdFilterTypeFair;
extern NSString* const kAdFilterTypeFishy;
extern NSString* const kAdFilterTypeFail;

#pragma mark - Display constants

#define kSPBlueTextColor [UIColor colorWithRed: 35.0/255.0 green: 40.0/255.0 blue: 76.0/255.0 alpha: 1.0]
#define kSPDarkBlueTextColor [UIColor colorWithRed: 35.0/255.0 green:40.0/255.0 blue: 76.0/255.0 alpha: 1.0]
#define kSPAdDetailRedAreaColor [UIColor colorWithRed: 190.0/255.0 green: 9.0/255.0 blue: 14.0/255.0 alpha: 1.0]

#define kSPAdDetailAffiliationBulletImageName @""
