//
//  NSDictionary+Claim.h
//  SuperPAC
//
//  Created by Alex Rouse on 7/24/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kFactCheckNameVal @"FactCheck.org"
#define kPolitiFactNameVal @"PolitiFact"

@interface NSDictionary (Claim)

- (NSString*)claimTitle;
- (NSArray*)sources;

- (NSDictionary*)claimSourceAtIndex:(NSInteger) sourceIndex;
- (NSInteger)politifactClaimSourceIndex;  //index of the first politifact source encountered or -1
- (NSInteger)factCheckOrgClaimSourceIndex; //index of  the first factCheck.orgsource encountered or -1
- (NSDictionary *)politifactClaimSource;  //returns the first politifact source encountered or nil
- (NSDictionary *)factCheckOrgClaimSource; //returns the first factCheck.org source encountered or nil

- (NSString*)claimSourceName;
- (NSString*)claimSourceUrl;
- (NSString*)claimSourceBaseUrl;

@end
