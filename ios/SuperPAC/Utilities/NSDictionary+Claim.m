//
//  NSDictionary+Claim.m
//  SuperPAC
//
//  Created by Alex Rouse on 7/24/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import "NSDictionary+Claim.h"
#import "NSDictionary+NonNSNull.h"

@implementation NSDictionary (Claim)

- (NSString*)claimTitle {
    NSString *cTitle = [self validObjectForKey:kClaimText];
    if (!cTitle){
        cTitle = [[self validObjectForKey:kClaim] validObjectForKey:kClaimText];
    }
    return cTitle;
}

- (NSArray*)sources
{
    NSArray *cSourceUrls = [self validObjectForKey:kClaimSourceList];
    if (!cSourceUrls){
        cSourceUrls = [[self validObjectForKey:kClaim] validObjectForKey:kClaimSourceList];
    }
    return cSourceUrls;
}


- (NSString*)baseUrlForSourceAtIndex:(NSInteger) sourceIndex
{
    NSString *fullUrl = [self fullUrlForSourceAtIndex:sourceIndex];
    NSString *baseUrl = nil;
    if(fullUrl){
        baseUrl = nil;// baseURL from the full URL string
    }
    return baseUrl;
}

- (NSString*)fullUrlForSourceAtIndex:(NSInteger) sourceIndex
{
    NSString *fullUrl = nil;
    NSDictionary *claimSource = [self claimSourceAtIndex:sourceIndex];
    if(claimSource){
        fullUrl = [claimSource validObjectForKey:kClaimSourceUrl];
    }
    return fullUrl;
}
- (NSString*)nameForSourceAtIndex:(NSInteger) sourceIndex
{
    NSString *fullUrl = nil;
    NSDictionary *claimSource = [self claimSourceAtIndex:sourceIndex];
    if(claimSource){
        fullUrl = [claimSource validObjectForKey:kClaimSourceName];
    }
    return fullUrl;
}


//Claim Source
- (NSDictionary*)claimSourceAtIndex:(NSInteger) sourceIndex
{
    NSDictionary *claimSource = nil;
    if([self sources] && (sourceIndex < [[self sources] count])){
        claimSource = [[self sources] objectAtIndex:sourceIndex];
        if([claimSource validObjectForKey:kClaimSource]){
            claimSource = [claimSource validObjectForKey:kClaimSource];
        }
    }
    return claimSource;
}


- (NSInteger)politifactClaimSourceIndex
{ //index of the first politifact source encountered or -1
    NSInteger indexFound = -1;
    NSArray *allSources = [self sources];
    for(int i = 0; i < [allSources count]; i++){
       NSString *nameCheck = [self nameForSourceAtIndex:i];
        if([nameCheck isEqualToString:kPolitiFactNameVal]){
            indexFound = i;
            break; 
        }
    }
    return indexFound;
}  
- (NSInteger)factCheckOrgClaimSourceIndex
{ //index of  the first factCheck.orgsource encountered or -1
    NSInteger indexFound = -1;
    NSArray *allSources = [self sources];
    for(int i = 0; i < [allSources count]; i++){
        NSString *nameCheck = [self nameForSourceAtIndex:i];
        if([nameCheck isEqualToString:kFactCheckNameVal]){
            indexFound = i;
            break; 
        }
    }
    return indexFound;
} 
- (NSDictionary *)politifactClaimSource
{ //returns the first politifact source encountered or nil
    NSDictionary *toRet = nil;
    NSInteger indexFound = [self politifactClaimSourceIndex];
    if(indexFound >= 0){
        toRet = [[self sources] objectAtIndex:indexFound]; 
    }
    return toRet;
}  
- (NSDictionary *)factCheckOrgClaimSource
{ //returns the first factCheck.org source encountered or nil
    NSDictionary *toRet = nil;
    NSInteger indexFound = [self politifactClaimSourceIndex];
    if(indexFound >= 0){
        toRet = [[self sources] objectAtIndex:indexFound]; 
    }
    return toRet;
} 


- (NSString*)claimSourceName
{
    NSString *toRet = [self validObjectForKey:kClaimSourceName];
    if(toRet == nil && [self validObjectForKey:kClaimSource])
    {
        toRet = [[self validObjectForKey:kClaimSource] validObjectForKey:kClaimSourceName];
    }
    return toRet;
}

- (NSString*)claimSourceUrl
{
    NSString *toRet = [self validObjectForKey:kClaimSourceUrl];
    if(toRet == nil && [self validObjectForKey:kClaimSource])
    {
        toRet = [[self validObjectForKey:kClaimSource] validObjectForKey:kClaimSourceUrl];
    }
    return toRet;
}

- (NSString*)claimSourceBaseUrl //localytics helper
{
    NSString *toRet = [self validObjectForKey:kClaimSourceName];
    if(toRet != nil)
    {
        toRet = nil;
    }
    return toRet;
}


@end
