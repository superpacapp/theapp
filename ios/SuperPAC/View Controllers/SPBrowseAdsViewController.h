//
//  SPBrowseAdsViewController.h
//  SuperPAC
//
//  Created by Nick Donaldson on 7/18/12.
//
//

#import <UIKit/UIKit.h>
#import "SPDataManager.h"
#import "SPAdFiltersViewController.h"

@interface SPBrowseAdsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, SPDataManagerDelegate, SPAdFilterDelegate>

@property (strong, nonatomic) IBOutlet UITableView *committeesTableView;
@property (weak, nonatomic) IBOutlet UIButton *bananaPeelButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinner;

@end
