//
//  NSDictionary+MyTagsSort.h
//  SuperPAC
//
//  Created by Nick Donaldson on 8/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (MyTagsSort)

- (NSComparisonResult)compareTagTitle:(NSDictionary*)tagDict;

@end
