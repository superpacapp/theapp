//
//  NSDate+PrintHelpers.h
//  SuperPAC
//
//  Created by Alex Rouse on 7/24/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (PrintHelpers)

- (NSString *)displayTimeSinceNow;
- (int)secondsBeforeNow;

@end
