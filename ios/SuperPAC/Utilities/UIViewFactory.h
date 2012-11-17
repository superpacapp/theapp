//
//  UIViewFactory.h
//  SuperPAC
//
//  Created by Alex Rouse on 7/24/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (UIViewFactory)
+ (UIView *)view;
@end

@interface UIViewFactory : NSObject {
    UIView *_view;
}

@property (nonatomic, strong) IBOutlet UIView *view;

+ (UIView *)viewWithNibNamed:(NSString *)nibName;

@end
