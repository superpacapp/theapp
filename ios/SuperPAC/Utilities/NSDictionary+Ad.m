//
//  NSDictionary+Ad.m
//  SuperPAC
//
//  Created by Nick Donaldson on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+Ad.h"
#import "NSString+HTMLEntities.h"
#import "NSDictionary+NonNSNull.h"

@implementation NSDictionary (Ad)

- (NSNumber*)adId
{
    NSNumber *adid = [self validObjectForKey:kAdId];
    if (!adid){
        adid = [[self validObjectForKey:kAd] validObjectForKey:kAdId];
    }
    return adid;
}

- (NSString*)adTitle
{
    NSString *adt = [self validObjectForKey:kAdTitle];
    if (!adt){
        adt = [[self validObjectForKey:kAd] validObjectForKey:kAdTitle];
    }
    return [adt stringByDecodingHTMLEntities];
}

- (NSString*)adUpdatedAt
{
    NSString *adu = [self validObjectForKey:kAdUpdatedAt];
    if (!adu){
        adu = [[self validObjectForKey:kAd] validObjectForKey:kAdUpdatedAt];
    }
    return adu;
}

- (NSString*)uploadDate
{
    NSString *adu = [self validObjectForKey:kAdUploadDate];
    if (!adu){
        adu = [[self validObjectForKey:kAd] validObjectForKey:kAdUploadDate];
    }
    return [adu stringByDecodingHTMLEntities];
}

- (NSArray*)adClaims{
    NSArray *adclm = [self validObjectForKey:kAdClaims];
    if (!adclm){
        adclm = [[self validObjectForKey:kAd] validObjectForKey:kAdClaims];
    }
    return adclm;
}

- (NSString*)defaultClaimString
{
    NSArray *claims = [self adClaims];
    if (claims.count){
        return [[[[claims objectAtIndex:0] validObjectForKey:kClaim] validObjectForKey:kClaimText] stringByDecodingHTMLEntities];
    }
    return nil;
}

- (NSString*)youtubeUrl
{
    NSString *adt = [self validObjectForKey:kAdVideoURL];
    if (!adt){
        adt = [[self validObjectForKey:kAd] validObjectForKey:kAdVideoURL];
    }
    return adt;
}

- (NSString*)thumbnailUrl
{
    NSString *adt = [self validObjectForKey:kAdThumbnailURL];
    if (!adt){
        adt = [[self validObjectForKey:kAd] validObjectForKey:kAdThumbnailURL];
    }
    return adt;
}

- (NSString*)adUploadDate
{
    NSString *adl = [self validObjectForKey:kAdUploadDate];
    if (!adl){
        adl = [[self validObjectForKey:kAd] validObjectForKey:kAdUploadDate];
    }
    return adl;
}


- (NSNumber*)adLength
{
    NSNumber *adl = [self validObjectForKey:kAdLength];
    if (!adl){
        adl = [[self validObjectForKey:kAd] validObjectForKey:kAdLength];
    }
    return adl;
}

- (NSDictionary*) committee
{
    NSDictionary *cm = [self validObjectForKey:kCommittee];
    if (!cm){
        cm = [[self validObjectForKey:kAd] validObjectForKey:kCommittee];
    }
    return cm;
}

- (NSString*)   adTitleForBackButton
{
    NSString *fullTitle = [self adTitle];
    if([fullTitle length] > 9){
        NSString *titleTruncated = [fullTitle substringToIndex:8];
        return [NSString stringWithFormat:@"%@...", titleTruncated];
    }else
    {
        return fullTitle;
    }
}

- (NSDictionary*)tags
{
    NSDictionary *thetags = [self validObjectForKey:kAdTags];
    if (!thetags){
        thetags = [[self validObjectForKey:kAd] validObjectForKey:kAdTags];
    }
    return thetags;
}


- (NSArray*)sortedTags
{
    NSMutableArray *toRet = [NSMutableArray array];
    NSMutableDictionary *remainingTags = [[self tags] mutableCopy];
    
    while([self topTagForDict:remainingTags] != nil){
        NSString *topKey = [self topTagForDict:remainingTags];
        NSString *tagTitle = [topKey uppercaseString];
        NSString *tagImageUrl = @""; 
        if([tagTitle isEqualToString:@"LOVE"])
        {
            tagImageUrl = @"love_icon_small.png";
        }else if([tagTitle isEqualToString:@"FAIR"])
        {
            tagImageUrl = @"fair_icon_small.png";
        }else if([tagTitle isEqualToString:@"FISHY"])
        {
            tagImageUrl = @"fishy_icon_small.png";
        }else if([tagTitle isEqualToString:@"FAIL"])
        {
            tagImageUrl = @"fail_icon_small.png";
        }
     
        NSString *tagPercent = @"";
        
        // account for both decimal numbers and strings
        id tagValue = [remainingTags validObjectForKey:topKey];
        if ([tagValue isKindOfClass:[NSString class]]){
            tagPercent = tagValue;
        }
        else if ([tagValue isKindOfClass:[NSNumber class]]){
            tagPercent = [NSString stringWithFormat:@"%d%%",(int)([[remainingTags validObjectForKey:topKey] floatValue]*100)];
        }
        [remainingTags removeObjectForKey:topKey];
        NSMutableDictionary *nextTag = [NSMutableDictionary dictionaryWithObjectsAndKeys:tagImageUrl, @"tagImageUrl", tagTitle, @"tagTitle", tagPercent, @"tagPercent", nil];
        [toRet addObject:nextTag];
    }
    return toRet;
}

- (NSString*)topTagForDict:(NSMutableDictionary *)tagsDict
{
    if (tagsDict){
        NSString *thetop = nil;
        float topPercentage = -1;
        NSArray *tagKeys = [tagsDict allKeys];
        for (NSString *tagKey in tagKeys){
            float percentage = [[tagsDict valueForKey:tagKey] floatValue];
            if (percentage > topPercentage){
                topPercentage = percentage;
                thetop = tagKey;
            }
        }
        if (topPercentage < 0) {
            return nil;
       }
        
        return thetop;
    }
    return nil;

}


- (NSString*)topTag
{
    NSDictionary *tags = [self tags];
    if (tags){
        NSString *thetop = nil;
        float topPercentage = 0;
        NSArray *tagKeys = [tags allKeys];
        for (NSString *tagKey in tagKeys){
            float percentage = [[tags valueForKey:tagKey] floatValue];
            if (percentage > topPercentage){
                topPercentage = percentage;
                thetop = tagKey;
            }
        }
        return thetop;
    }
    return nil;
}

- (NSString*)lastTag
{
    NSString *lt = [self validObjectForKey:kAdLastTag];
    if (!lt){
        lt = [[self validObjectForKey:kAd] validObjectForKey:kAdLastTag];
    }

    return lt;
}

- (double)latitude
{
    NSNumber *adl = [self validObjectForKey:kAdLatitude];
    if (!adl){
        adl = [[self validObjectForKey:kAd] validObjectForKey:kAdLatitude];
    }
    return [adl doubleValue];
}

- (double)longitude
{
    NSNumber *adl = [self validObjectForKey:kAdLongitude];
    if (!adl){
        adl = [[self validObjectForKey:kAd] validObjectForKey:kAdLongitude];
    }
    return [adl doubleValue];
}

- (BOOL)hasCoordinate
{
    NSNumber *adl = [self validObjectForKey:kAdLatitude];
    if (!adl){
        adl = [[self validObjectForKey:kAd] validObjectForKey:kAdLatitude];
    }
    
    NSNumber *adlt = [self validObjectForKey:kAdLongitude];
    if (!adlt){
        adlt = [[self validObjectForKey:kAd] validObjectForKey:kAdLongitude];
    }
    
    return (adl != nil) && (adlt != nil);
}


@end
