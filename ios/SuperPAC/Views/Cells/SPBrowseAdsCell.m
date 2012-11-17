//
//  SPBrowseAdsCell.m
//  SuperPAC
//
//  Created by Nick Donaldson on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SPBrowseAdsCell.h"
#import "RZFileManager.h"
#import "SPDataManager.h"
#import "NSDictionary+Ad.h"
#import "NSData+ValidJPEG.h"
#import "NSDate+PrintHelpers.h"
#import "UIImage+JTImageDecode.h"

#define kImageFadeDuration 0.15
#define kImageTestURL @"http://a0.twimg.com/profile_images/1420747836/Blog_-_Derp_Durp_-_Twitter_foto_reasonably_small.jpg"

@interface SPBrowseAdsCell ()

- (void)setTagImageForTag:(NSString*)tag;
- (void)updateThumbnailImage:(UIImage*)image animated:(BOOL)animated;


@end


@implementation SPBrowseAdsCell

@synthesize adImageView = _adImageView;
@synthesize alreadyVotedOverlayImage = _alreadyVotedOverlayImage;
@synthesize tagImageView = _tagImageView;
@synthesize imageBorderView = _imageBorderView;
@synthesize adTitleLabel = _adTitleLabel;
@synthesize percentageLabel = _percentageLabel;
@synthesize tagLabel = _tagLabel;
@synthesize loadingSpinner = _loadingSpinner;
@synthesize selectedOverlay = _selectedOverlay;
@synthesize vidLengthLabel = _vidLengthLabel;
@synthesize dateUploadedLabel = _dateUploadedLabel;
@synthesize loading = _loading;
@synthesize ad = _ad;
@synthesize adDetailRequest = _adDetailRequest;

- (void)awakeFromNib
{
}

- (void)prepareForReuse
{
    self.loading = YES;
    self.adImageView.image = [UIImage imageNamed:@"thumbnail_placeholder"];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    CGFloat targetAlpha = highlighted ? 1.0f : 0.0f;
    if (animated){
        [UIView animateWithDuration:0.1
                         animations:^{
                             self.selectedOverlay.alpha = targetAlpha;
                         }];
    }
    else{
        self.selectedOverlay.alpha = targetAlpha;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    CGFloat targetAlpha = selected ? 1.0f : 0.0f;
    if (animated){
        [UIView animateWithDuration:0.1
                         animations:^{
                             self.selectedOverlay.alpha = targetAlpha;
                         }];
    }
    else{
        self.selectedOverlay.alpha = targetAlpha;
    }
}

- (void)setAd:(NSDictionary *)ad
{
    [self setAd:ad whileVisible:NO];
}

- (void)setAd:(NSDictionary *)ad whileVisible:(BOOL)visible
{
    _ad = ad;
    if (ad){
        
        // set loading state first, so we can hide tag labels if necessary
        self.loading = NO;
        self.adDetailRequest = nil;
        
        NSString *title = [ad adTitle];
        _adTitleLabel.text = title ? title : @"";
        
        NSInteger lengthInSeconds = [[ad adLength] intValue];
        NSInteger lengthMins = lengthInSeconds/60.0f;
        NSInteger lengthSeconds = lengthInSeconds % 60;
        _vidLengthLabel.text = [NSString stringWithFormat:@"%d:%02d",lengthMins,lengthSeconds];
        
        _dateUploadedLabel.text = [ad uploadDate];
        
        NSString *topTag = [ad topTag];
        if (topTag){
            [self setTagImageForTag:topTag];
            NSString *percentageText = @"";
            id topTagValue = [[ad tags] objectForKey:topTag];
            if ([topTagValue isKindOfClass:[NSString class]]){
                percentageText = topTagValue;
            }
            else if ([topTagValue isKindOfClass:[NSNumber class]]){
                percentageText = [NSString stringWithFormat:@" %d%% %@",(int)([topTagValue floatValue]*100), [topTag uppercaseString]];
            }
            
            self.percentageLabel.text = percentageText;
            _percentageLabel.hidden = NO;
            _tagImageView.hidden = NO;
        }
        else{
            _percentageLabel.hidden = YES;
            _tagImageView.hidden = YES;
        }
        
        
        [self updateTagDisplay];
                
        // load image
        NSString *imagePath = [ad thumbnailUrl];
        if (![imagePath isEqual:[NSNull null]]){
            
            RZFileManager *fm = [[SPDataManager sharedInstance] imageFileManager];
            
            [fm downloadFileFromURL:[NSURL URLWithString:imagePath]
               withProgressDelegate:nil
                         completion:^(BOOL success, NSURL *downloadedFile, RZWebServiceRequest *request) {
                             if (success){
                                 NSString *imageURL = [[self ad] thumbnailUrl];
                                 if (![imageURL isEqual:[NSNull null]]){
                                     
                                     // if request is nil, we got it immediately
                                     // otherwise, we need to verify it's the right one for this cell, due to cell reuse
                                     if ([request.url.absoluteString isEqualToString:imageURL] || !request){
                                         
                                         // check bad JPEG
                                         NSData* imgData = [NSData dataWithContentsOfURL:downloadedFile];
                                         if ([imgData isValidJPEG]){
                                             UIImage *image = [UIImage imageWithData:imgData];
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [self updateThumbnailImage:image animated:visible];
                                             });
                                         }
                                         else{
                                             [[RZFileManager defaultManager] deleteFileFromCacheWithURL:downloadedFile];
                                         }

                                     }
                                 }
                             }
                         }];
        
        }
        else{
            self.adImageView.image = [UIImage imageNamed:@"thumbnail_placeholder"];
        }
        
        
        // hide the claim label if no claim string
    }
    else {
        self.loading = YES;
        self.adImageView.image = [UIImage imageNamed:@"thumbnail_placeholder"];
    }
}
- (void)setTagImageForTag:(NSString *)tag
{
    if ([tag isEqualToString:kAdTagFail]){
        self.tagImageView.image = [UIImage imageNamed:@"fail_icon_small"];
    }
    else if ([tag isEqualToString:kAdTagFair]){
        self.tagImageView.image = [UIImage imageNamed:@"fair_icon_small"];
    }
    else if ([tag isEqualToString:kAdTagFishy]){
        self.tagImageView.image = [UIImage imageNamed:@"fishy_icon_small"];
    }
    else if ([tag isEqualToString:kAdTagLove]){
        self.tagImageView.image = [UIImage imageNamed:@"love_icon_small"];
    }
}


- (void)updateThumbnailImage:(UIImage *)image animated:(BOOL)animated
{
    
    if (image){        
        
        if (animated){
            [UIView transitionWithView:self.adImageView
                              duration:kImageFadeDuration
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                self.adImageView.image = image;
                            }
                            completion:NULL];
        }
        else{
            self.adImageView.image = image;
        }

    }
    else{
        self.adImageView.image =  [UIImage imageNamed:@"thumbnail_placeholder"];
    }
}

- (void)setLoading:(BOOL)loading
{
    _loading = loading;
    _adTitleLabel.hidden = loading;

    _dateUploadedLabel.hidden = loading;
    _tagImageView.hidden = loading;
    _percentageLabel.hidden = loading;
    _tagLabel.hidden = loading;
    _alreadyVotedOverlayImage.hidden = loading;
    _vidLengthLabel.hidden = loading;
    
    if (loading){
        [_loadingSpinner startAnimating];
    }
    else{
        [_loadingSpinner stopAnimating];
    }
}

-(void)updateTagDisplay
{
    NSString *tagCheck = [[SPDataManager sharedInstance] tagForAdId:[_ad adId]];
    if (tagCheck){
        self.tagLabel.text = [tagCheck uppercaseString];
        _tagLabel.hidden  = NO;
        _alreadyVotedOverlayImage.hidden = NO;
    }
    else{
        _tagLabel.hidden = YES;
        _alreadyVotedOverlayImage.hidden = YES;
    }

}

@end
