//
//  NSDictionary+MyTagsSort.m
//  SuperPAC
//
//  Created by Nick Donaldson on 8/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+MyTagsSort.h"
#import "NSDictionary+NonNSNull.h"

@implementation NSDictionary (MyTagsSort)

- (NSComparisonResult)compareTagTitle:(NSDictionary*)tagDict{
    
    NSString *myAdTitle = [self validObjectForKey:kAdTitle];
    NSString *otherAdTitle = [tagDict validObjectForKey:kAdTitle];
    
    if (myAdTitle && otherAdTitle)
        return [[self validObjectForKey:kAdTitle] caseInsensitiveCompare:[tagDict validObjectForKey:kAdTitle]];
    
    return NSOrderedSame;
}

@end
