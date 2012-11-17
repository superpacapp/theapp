//
//  NSDictionary+Committee.m
//  SuperPAC
//
//  Created by Nick Donaldson on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+Committee.h"
#import "NSString+HTMLEntities.h"

@implementation NSDictionary (Committee)

- (NSString*)committeeId
{
    NSString *cmId = [self objectForKey:kCommitteeId];
    if (!cmId){
        cmId = [[self objectForKey:kCommittee] objectForKey:kCommitteeId];
    }
    return cmId;
}

- (NSString*)committeeName
{
    NSString* cmName = [self objectForKey:kCommitteeName];
    if (!cmName){
        cmName = [[self objectForKey:kCommittee] objectForKey:kCommitteeName];
    }
    return [cmName stringByDecodingHTMLEntities];
}

- (NSArray*)committeeAdIds
{
    NSArray *cmAdIds = [self objectForKey:kCommitteeAdIds];
    if (!cmAdIds){
        cmAdIds = [[self objectForKey:kCommittee] objectForKey:kCommitteeAdIds];
    }
    return cmAdIds;
}

- (NSArray*)committeeAds
{
    NSArray *cmAds = [self objectForKey:kCommitteeAds];
    if (!cmAds){
        cmAds = [[self objectForKey:kCommittee] objectForKey:kCommitteeAds];
    }
    return cmAds;
}

- (NSString*)committeeTotalRaised
{
    NSString *cmRaised = [self objectForKey:kCommitteeTotalRaised];
    if (!cmRaised){
        cmRaised = [[self objectForKey:kCommittee] objectForKey:kCommitteeTotalRaised];
    }
    return cmRaised ;
}

- (NSString*)committeeTotalSpent
{
    NSString *cmSpent = [self objectForKey:kCommitteeTotalSpent];
    if (!cmSpent){
        cmSpent = [[self objectForKey:kCommittee] objectForKey:kCommitteeTotalSpent];
    }
    return cmSpent;
}


- (NSString*)committeeSuppOpp
{
    NSString *cmSuppOpp = [self objectForKey:kCommitteeSupportOppose];
    if (!cmSuppOpp && ![[NSNull null] isEqual:cmSuppOpp]){
        cmSuppOpp = [[self objectForKey:kCommittee] objectForKey:kCommitteeSupportOppose];
    }
    return cmSuppOpp;
}




- (NSArray*)committeeOrgTypeSuppOpp
{
    NSMutableArray *toRet = [NSMutableArray array];
    NSString *cmOrgType = [self objectForKey:kCommitteeOrgType];
    if (!cmOrgType){
        cmOrgType = [[self objectForKey:kCommittee] objectForKey:kCommitteeOrgType];
    }

    if(cmOrgType){
        [toRet addObject:cmOrgType];
    }
    NSString *suppOpp = [self committeeSuppOpp];
    if(suppOpp  && ![[NSNull null] isEqual:suppOpp]){
        [toRet addObject:suppOpp];
    }
    return toRet; 
}
@end
