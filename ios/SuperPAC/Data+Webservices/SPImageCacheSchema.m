//
//  SPImageCacheSchema.m
//  SuperPAC
//
//  Created by Nick Donaldson on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SPImageCacheSchema.h"

@implementation SPImageCacheSchema

- (NSURL *)cacheURLFromRemoteURL:(NSURL *)remoteURL
{
    // use the last 2 path components appended together e.g. /sB7vuo2piak/2.jpg --> sB7vuo2piak2.jpg
    NSArray *pathComponents = [remoteURL pathComponents];
    if (pathComponents.count < 2)
        return [[self downloadCacheDirectory] URLByAppendingPathComponent:[pathComponents lastObject]];
    
    NSString* cacheName = [[pathComponents subarrayWithRange:NSMakeRange(pathComponents.count-2, 2)] componentsJoinedByString:@""];
    NSURL* cachePath = [[self downloadCacheDirectory] URLByAppendingPathComponent:cacheName];
    return cachePath;
}

- (NSURL *)cacheURLFromCustomName:(NSString *)name
{
    NSURL* cacheURL = [[self downloadCacheDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%d",[name hash]]];
    return cacheURL;
}

@end
