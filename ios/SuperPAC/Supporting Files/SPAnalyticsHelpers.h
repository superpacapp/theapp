//
//  SPAnalyticsHelpers.h
//  SuperPAC
//
//  Created by Andrew Tremblay on 7/24/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SPAnalyticsHelpers;

@interface SPAnalyticsHelpers : NSObject
+ (SPAnalyticsHelpers *)shared;

- (BOOL) hasLaunched;
-(NSString *)filterValueFromFilters:(NSArray*)filters;
-(NSString *)baseUrlForSource:(NSInteger)sourceId inClaim:(NSDictionary*)claim;
@end
