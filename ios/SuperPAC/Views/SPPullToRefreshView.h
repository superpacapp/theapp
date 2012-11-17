//
//  SPPullToRefreshView.h
//  SuperPAC
//
//  Created by Alex Rouse on 7/24/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPullToRefreshHeight 67.0f
typedef enum{
	PullRefreshPulling = 0,
	PullRefreshNormal,
	PullRefreshLoading,	
} PullRefreshState;

@protocol SPPullToRefreshDelegate <NSObject>
- (void)issueRefresh;
@end

@interface SPPullToRefreshView : UIView

@property (nonatomic, strong) NSString *dataLoadType;
@property (nonatomic, assign) BOOL refreshActive;
@property (nonatomic, assign) PullRefreshState refreshState;
@property (nonatomic, weak) IBOutlet UILabel* pullText;
@property (nonatomic, weak) IBOutlet UILabel* pullDate;
@property (nonatomic, weak) IBOutlet UIImageView* refreshImage;
@property (nonatomic, weak) IBOutlet UIImageView* backgroundView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView* spinner;
@property (nonatomic, weak)UIScrollView* updateingScrollView;
@property (nonatomic, weak) id<SPPullToRefreshDelegate> delegate;
- (void)scrollViewScrolled:(UIScrollView *)scrollView;
- (void)scrollViewDidEndScrolling:(UIScrollView *)scrollView;
- (void)scrollViewWillBeginScrolling:(UIScrollView *)scrollView;
- (void)updateFinished;
- (void)forceRefresh;
- (void)updateView;
@end
