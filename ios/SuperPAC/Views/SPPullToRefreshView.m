//
//  SPPullToRefreshView.m
//  SuperPAC
//
//  Created by Alex Rouse on 7/24/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import "SPPullToRefreshView.h"
#import <QuartzCore/QuartzCore.h>

#define kInsetAnimationInterval         0.2
#define kArrowRotationDuration          0.3

@interface SPPullToRefreshView ()
@property (nonatomic, assign) BOOL scrollUpdateLocked;
@property (nonatomic, assign) PullRefreshState currentState;

- (void)viewUpdateForState:(PullRefreshState)state;
@end

@implementation SPPullToRefreshView

@synthesize refreshActive = _refreshActive;
@synthesize refreshState = _refreshState;
@synthesize pullText = _pullText;
@synthesize pullDate = _pullDate;
@synthesize refreshImage = _refreshImage;
@synthesize delegate = _delegate;
@synthesize dataLoadType = _dataLoadType;
@synthesize updateingScrollView = _updateingScrollView;
@synthesize backgroundView = _backgroundView;
@synthesize spinner = _spinner;

@synthesize scrollUpdateLocked = _scrollUpdateLocked;
@synthesize currentState = _currentState;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)updateView {
    self.backgroundView.image = [[UIImage imageNamed:@"refresh_background_stretchable"] stretchableImageWithLeftCapWidth:320 topCapHeight:7];
}

- (void)scrollViewScrolled:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= -kPullToRefreshHeight * 1.5 && !self.scrollUpdateLocked) {
        self.refreshState = PullRefreshPulling;
    } else if(!self.scrollUpdateLocked) {
        self.refreshState = PullRefreshNormal;
    }
    [self viewUpdateForState:self.refreshState];
}

- (void)scrollViewDidEndScrolling:(UIScrollView *)scrollView {
    if (self.refreshState == PullRefreshPulling) {
        self.scrollUpdateLocked = YES;
        self.refreshState = PullRefreshLoading;
        scrollView.scrollEnabled = NO;
        scrollView.userInteractionEnabled = NO;
        self.updateingScrollView = scrollView;
        [self.delegate issueRefresh];
        [self viewUpdateForState:self.refreshState];
    }
}

- (void)scrollViewWillBeginScrolling:(UIScrollView *)scrollView {
    self.refreshState = PullRefreshNormal;
    self.pullText.text = @"Pull To Refresh";
}

- (void)updateFinished {
    [self.spinner stopAnimating];
    self.refreshImage.hidden = NO;
    self.updateingScrollView.scrollEnabled = YES;
    self.updateingScrollView.userInteractionEnabled = YES;
    self.scrollUpdateLocked = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kInsetAnimationInterval];
    
    self.updateingScrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    [UIView commitAnimations];
    [self.refreshImage.layer removeAllAnimations];
    self.refreshState = PullRefreshNormal; 
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy hh:mma"];
    self.pullDate.text = [NSString stringWithFormat:@"Last Updated: %@", [dateFormat stringFromDate:today]];
    
    [self viewUpdateForState:self.refreshState];
}

- (void)viewUpdateForState:(PullRefreshState)state {
    if(state == self.currentState) {
        return;
    }
    self.currentState = state;
    switch (state) {
        case PullRefreshNormal:
            self.pullText.text = @"Pull Down To Refresh...";
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:kArrowRotationDuration];	
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            self.refreshImage.transform = CGAffineTransformMakeRotation(2*M_PI); 
            [UIView commitAnimations];
            break;
        case PullRefreshPulling:
            self.pullText.text = @"Release To Refresh";
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:kArrowRotationDuration];	
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            //Have to have the -0.001 so that we rotate the right direction
            self.refreshImage.transform = CGAffineTransformMakeRotation(M_PI-0.001f); 
            [UIView commitAnimations];
            
            break;
        case PullRefreshLoading:
        {
            [self.spinner startAnimating];
            self.refreshImage.hidden = YES;
            self.pullText.text = [NSString stringWithFormat:@"Refreshing %@",self.dataLoadType];;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:kInsetAnimationInterval];
            self.updateingScrollView.contentOffset = CGPointMake(0, -kPullToRefreshHeight);
            self.updateingScrollView.contentInset= UIEdgeInsetsMake(kPullToRefreshHeight, 0.0f, 0.0f, 0.0f);
            [UIView commitAnimations];
            break;
        }
        default:
            break;
    }
}

- (void)forceRefresh {
    self.scrollUpdateLocked = YES;
    self.refreshState = PullRefreshLoading;
    [self.delegate issueRefresh];
    [self.updateingScrollView scrollRectToVisible:self.frame animated:NO];
    self.updateingScrollView.scrollEnabled = NO;
    [self viewUpdateForState:self.refreshState];
}
@end
