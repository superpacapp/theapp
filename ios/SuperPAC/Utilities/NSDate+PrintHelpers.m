//
//  NSDate+PrintHelpers.m
//  SuperPAC
//
//  Created by Alex Rouse on 7/24/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import "NSDate+PrintHelpers.h"

@implementation NSDate (PrintHelpers)

- (NSString *)displayTimeSinceNow {
    int secondsBetween = [self secondsBeforeNow];
    if (secondsBetween < 60) {
        return [NSString stringWithFormat:@"Right Now"];
    }
    else if (secondsBetween < 3600) {
        int min = (int)(secondsBetween/60);
        return [NSString stringWithFormat:@"%d Min Ago",min];
    } 
    else if(secondsBetween < 86400) {
        int hrs = (int)(secondsBetween/3600.0f);
        return [NSString stringWithFormat:@"%d %@ Ago", hrs, hrs > 1 ? @"Hrs" : @"Hr" ];
    }
    else {
        int days = (int)(secondsBetween/86400);
        NSString *dayStringFormat = (days == 1)? @"%d Day Ago" : @"%d Days Ago"; 
        return [NSString stringWithFormat:dayStringFormat,days];
    }
}

- (int) secondsBeforeNow {
    return (int)[[NSDate date] timeIntervalSinceDate:self];
}

@end
