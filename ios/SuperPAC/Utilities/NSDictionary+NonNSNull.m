//
//  NSDictionary+NonNSNull.m
//  Rue La La
//
//  Created by Craig Spitzkoff on 2/2/12.
//  Copyright (c) 2012 Raizlabs Corporation. All rights reserved.
//

#import "NSDictionary+NonNSNull.h"

@implementation NSDictionary (NonNSNull)

-(id) validObjectForKey:(id)aKey
{
    id obj = [self objectForKey:aKey];
    if (obj == [NSNull null]) {
        obj = nil;
    }
    
    return obj;
}

-(id) validObjectForKeyPath:(id)aKeyPath
{
    id obj = [self valueForKeyPath:aKeyPath];
    if (obj == [NSNull null]) {
        obj = nil;
    }
    
    return obj;
}

-(id) numberForKey:(id)aKey
{
    id object = [self validObjectForKey:aKey];
    
    if([object isKindOfClass:[NSString class]])
    {
        NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        object = [formatter numberFromString:object];
    }
    else if(![object isKindOfClass:[NSNumber class]])
    {
        object = nil;
    }
    
    return object;
}

@end
