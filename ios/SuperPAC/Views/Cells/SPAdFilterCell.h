//
//  SPAdFilterCell.h
//  SuperPAC
//
//  Created by Andrew Khatutsky on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPAdFilterCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *filterCheckbox;
@property (nonatomic, weak) IBOutlet UILabel *filterLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectionOverlay;

@end
