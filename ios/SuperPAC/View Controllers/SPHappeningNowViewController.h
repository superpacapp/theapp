//
//  SPHappeningNowViewController.h
//  SuperPAC
//
//  Created by Nick Donaldson on 7/18/12.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SPPullToRefreshView.h"
#import "SPDataManager.h"

@interface SPHappeningNowViewController : UIViewController <SPPullToRefreshDelegate, SPDataManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic)     IBOutlet UIActivityIndicatorView *loadingSpinner;
@property (strong, nonatomic)   IBOutlet UITableView* happeningNowTableView;
@property (strong, nonatomic)   IBOutlet MKMapView *adsMapView;
@property (strong, nonatomic)   IBOutlet UIImageView *mapFrameImage;
@property (strong, nonatomic)   NSArray* allHappeningNowAds;

@end
