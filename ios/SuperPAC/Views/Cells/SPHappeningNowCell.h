//
//  SPHappeningNowCell.h
//  SuperPAC
//
//  Created by Alex Rouse on 7/24/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPHappeningNowCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel* timeLabel;
@property (nonatomic, weak) IBOutlet UILabel* headingLabel;
@property (nonatomic, weak) IBOutlet UILabel* superPacLabel;
@property (nonatomic, weak) IBOutlet UIImageView* mainImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectionOverlay;
@property (nonatomic, strong) NSDictionary* currentAd;

@end
