//
//  NSDictionary+NonNSNull.h
//  Rue La La
//
//  Created by Craig Spitzkoff on 2/2/12.
//  Copyright (c) 2012 Raizlabs Corporation. All rights reserved.
//
//  Category that checks a value for NSNull before returning it.
#import <Foundation/Foundation.h>

@interface NSDictionary (NonNSNull)

-(id) validObjectForKey:(id)aKey;
-(id) validObjectForKeyPath:(id)aKeyPath;

// ensure the valuue we return is of NSNumber. We'll convert it if we can.
-(id) numberForKey:(id)aKey;

@end
