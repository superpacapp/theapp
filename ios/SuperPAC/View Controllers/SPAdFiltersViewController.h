//
//  SPAdFiltersViewController.h
//  SuperPAC
//
//  Created by Andrew Khatutsky on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//Types of filters
enum {
    TypeFilterRecent = 0,
    TypeFilterPopular,
    TypeFilterProObama,
    TypeFilterProRomney,
    TypeFilterAntiObama,
    TypeFilterAntiRomney,
    TypeFilterLoved,
    TypeFilterFair,
    TypeFilterFishy,
    TypeFilterFail,
    nFilterTypes
};

@protocol SPAdFilterDelegate <NSObject>

// "filters" is an array of booleans as NSNumbers to signify which filters are on/off

- (void)updateFilters:(NSSet*)filters;

@end

@interface SPAdFiltersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *dismissSettingsButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *clearFiltersButton;
@property (nonatomic, weak) IBOutlet UITableView *filtersTable;
@property (nonatomic, strong) NSMutableSet *filterSettings;

@property (nonatomic, weak) id<SPAdFilterDelegate> filterDelegate;

- (IBAction)dismissFilters:(id)sender;
- (IBAction)clearFilters:(id)sender;

@end
