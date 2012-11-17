//
//  SPAdSourcesViewController.h
//  SuperPAC
//
//  Created by Andrew Tremblay on 7/24/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPFactCheckView.h"

@interface SPAdSourcesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, SPFactCheckDelegate>

@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet UILabel* committeeLabel;
@property (nonatomic, weak) IBOutlet UILabel* adNameLabel;

@property (nonatomic, strong) NSDictionary* currentAd;

-(void)loadURL:(NSString*)factURL withTitle:(NSString*)titleString;

@end

