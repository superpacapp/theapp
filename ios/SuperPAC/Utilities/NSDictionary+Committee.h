//
//  NSDictionary+Committee.h
//  SuperPAC
//
//  Created by Nick Donaldson on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Committee)

- (NSString*)committeeId;
- (NSString*)committeeName;
- (NSArray*)committeeAdIds;
- (NSArray*)committeeAds;
- (NSString*)committeeTotalRaised;
- (NSString*)committeeTotalSpent;
- (NSString*)committeeSuppOpp;
- (NSArray*)committeeOrgTypeSuppOpp;

@end
