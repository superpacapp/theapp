//
//  NSString+HTMLEntities.h
//  Rue La La
//
//  Created by Jeremy Debate on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (HTMLEntities) 

- (NSString *)stringByDecodingHTMLEntities;

@end
