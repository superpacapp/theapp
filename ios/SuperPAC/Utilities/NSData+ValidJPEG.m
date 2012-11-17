//
//  NSData+ValidJPEG.m
//  SuperPAC
//
//  Created by Nick Donaldson on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSData+ValidJPEG.h"

@implementation NSData (ValidJPEG)
- (BOOL)isValidJPEG
{
    if (self.length < 2) return NO;
    
    NSInteger totalBytes = self.length;
    const char *bytes = (const char*)[self bytes];
    
    return (bytes[0] == (char)0xff && 
            bytes[1] == (char)0xd8 &&
            bytes[totalBytes-2] == (char)0xff &&
            bytes[totalBytes-1] == (char)0xd9);
}
@end
