//
//  SPImageCacheSchema.h
//  SuperPAC
//
//  Created by Nick Donaldson on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RZCacheSchema.h"

@interface SPImageCacheSchema : RZCacheSchema

- (NSURL *)cacheURLFromRemoteURL:(NSURL *)remoteURL;
- (NSURL *)cacheURLFromCustomName:(NSString *)name;

@end
