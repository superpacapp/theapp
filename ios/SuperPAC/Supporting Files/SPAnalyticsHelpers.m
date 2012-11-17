//
//  SPAnalyticsHelpers.m
//  SuperPAC
//
//  Created by Andrew Tremblay on 7/24/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import "SPAnalyticsHelpers.h"
// The singleton session object.

#define kSPIsFirstLoadKey @"SPIsFirstLoadKey"


static SPAnalyticsHelpers *_shared = nil;

@implementation SPAnalyticsHelpers


+ (SPAnalyticsHelpers *)shared {    
	@synchronized(self) {
		if (_shared == nil) {
			_shared = [[self alloc] init];
		}
	}
	return _shared;
}

- (SPAnalyticsHelpers *)init {
	if((self = [super init])) {
        //default vars        
    }
    
    return self;
}

- (BOOL) hasLaunched {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL toRet = [defaults boolForKey:kSPIsFirstLoadKey]; 
    [defaults setBool:YES forKey:kSPIsFirstLoadKey];
    if([defaults synchronize]){
        return toRet; 
    }else{
        //return the value we think it is
        return toRet; 
    }
}


-(NSString *)filterValueFromFilters:(NSArray*)filters;
{
    if([filters count] != 1){
        return [NSString stringWithFormat:@"%i Filters", [filters count]];
    }
    
    NSString *singleFilter = [filters objectAtIndex:0];
    return singleFilter;
}

-(NSString *)baseUrlForSource:(NSInteger)sourceId inClaim:(NSDictionary*)claim
{
    return @"";

}


@end
