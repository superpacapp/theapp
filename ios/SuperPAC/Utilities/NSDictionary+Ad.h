//
//  NSDictionary+Ad.h
//  SuperPAC
//
//  Created by Nick Donaldson on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Ad)

- (NSNumber*)   adId;
- (NSString*)   adTitle;
- (NSString*)   adUpdatedAt;
- (NSString*)   uploadDate;
- (NSArray*)    adClaims;
- (NSString*)   defaultClaimString;
- (NSString*)   youtubeUrl;
- (NSString*)   thumbnailUrl;
- (NSString*)   adUploadDate;
- (NSNumber*)     adLength;
- (NSDictionary*) committee;
- (NSDictionary*) tags;
- (NSString*)     topTag;
- (NSString*)     lastTag;
- (NSArray*)sortedTags;
- (NSString*)topTagForDict:(NSDictionary *)tagsDict;

- (NSString*)   adTitleForBackButton;

- (double)      latitude;
- (double)      longitude;
- (BOOL)        hasCoordinate;

@end
