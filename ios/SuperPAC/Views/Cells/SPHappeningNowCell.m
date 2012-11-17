//
//  SPHappeningNowCell.m
//  SuperPAC
//
//  Created by Alex Rouse on 7/24/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import "SPHappeningNowCell.h"
#import "NSDate+PrintHelpers.h"
#import "NSDictionary+Ad.h"
#import "NSDictionary+Committee.h"

@implementation SPHappeningNowCell
@synthesize headingLabel = _headingLabel;
@synthesize mainImageView = _mainImageView;
@synthesize timeLabel = _timeLabel;
@synthesize superPacLabel = _superPacLabel;
@synthesize currentAd = _currentAd;
@synthesize selectionOverlay = _selectionOverlay;

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
- (void)setCurrentAd:(NSDictionary *)currentAd {
    if (_currentAd == currentAd) {
        return;
    }
    _currentAd = currentAd;
    self.headingLabel.text = currentAd.adTitle;
    self.superPacLabel.text = currentAd.committee.committeeName;
        
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];   
    [dateFormatter setDateFormat:kUpdatedAtTimestampFormat];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    NSString* tempString = [currentAd adUpdatedAt];
    NSString* date = [[tempString componentsSeparatedByString:@"+"] objectAtIndex:0];
    NSDate *currentDate = [dateFormatter dateFromString:date];
    self.timeLabel.text = [currentDate displayTimeSinceNow];
    [self.timeLabel sizeToFit];
    self.mainImageView.image = [self imageForTag:[[currentAd lastTag] lowercaseString]];
}


- (UIImage *)imageForTag:(NSString *)tag {
    if([tag isEqualToString:@"love"]) {
        return [UIImage imageNamed:@"love_icon_small"];
    } else if ([tag isEqualToString:@"fail"]) {
        return [UIImage imageNamed:@"fail_icon_small"];
    } else if ([tag isEqualToString:@"fishy"]) {
        return [UIImage imageNamed:@"fishy_icon_small"];
    } else {
        return [UIImage imageNamed:@"fair_icon_small"];
    }
}
@end
