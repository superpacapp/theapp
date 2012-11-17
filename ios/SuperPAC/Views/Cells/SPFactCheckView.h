//
//  SPFactCheckView.h
//  SuperPAC
//
//  Created by Andrew Khatutsky on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SPFactCheckDelegate <NSObject>
- (void)loadURL:(NSString*)factURL withTitle:(NSString *)titleString;
@end

@interface SPFactCheckView : UIView
@property (strong, nonatomic) NSDictionary *claimData;

@property (weak, nonatomic) IBOutlet UILabel *factCheckLabel;
@property (weak, nonatomic) IBOutlet UIButton *factcheckButton;
@property (weak, nonatomic) IBOutlet UIImageView *factCheckCheckBox;

@property (weak, nonatomic) IBOutlet UIButton *politifactButton;
@property (weak, nonatomic) IBOutlet UIImageView *politifactCheckBox;

@property (weak, nonatomic) id<SPFactCheckDelegate> factCheckDelegate;
@property (strong, nonatomic) IBOutlet UIImageView *dividerImage;

- (IBAction) factcheckPressed:(id)sender;
- (IBAction) politifactPressed:(id)sender;


@end
