//
//  SPAdFilterCell.m
//  SuperPAC
//
//  Created by Andrew Khatutsky on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SPAdFilterCell.h"

@implementation SPAdFilterCell

@synthesize filterLabel;
@synthesize selectionOverlay;
@synthesize filterCheckbox;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    CGFloat targetAlpha = highlighted ? 1.0f : 0.0f;
    if (animated){
        [UIView animateWithDuration:0.1
                         animations:^{
                             self.selectionOverlay.alpha = targetAlpha;
                         }];
    }
    else{
        self.selectionOverlay.alpha = targetAlpha;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    CGFloat targetAlpha = selected ? 1.0f : 0.0f;
    if (animated){
        [UIView animateWithDuration:0.1
                         animations:^{
                             self.selectionOverlay.alpha = targetAlpha;
                         }];
    }
    else{
        self.selectionOverlay.alpha = targetAlpha;
    }
}

@end
