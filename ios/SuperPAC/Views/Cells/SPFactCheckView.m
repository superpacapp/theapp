//
//  SPFactCheckView.m
//  SuperPAC
//
//  Created by Andrew Khatutsky on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SPFactCheckView.h"
#import "NSDictionary+Claim.h"

@implementation SPFactCheckView
@synthesize claimData = _claimData;

@synthesize factCheckLabel = _factCheckLabel;
@synthesize factcheckButton = _factcheckButton;
@synthesize factCheckCheckBox = _factCheckCheckBox;
@synthesize politifactButton = _politifactButton;
@synthesize politifactCheckBox = _politifactCheckBox;
@synthesize factCheckDelegate = _factCheckDelegate;
@synthesize dividerImage = _dividerImage;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction) factcheckPressed:(id)sender{
    NSDictionary *sourcePressed = [self.claimData factCheckOrgClaimSource];
    [self.factCheckDelegate loadURL:[sourcePressed claimSourceUrl] withTitle:@"FactCheck.org"];
}
- (IBAction) politifactPressed:(id)sender{
    NSDictionary *sourcePressed = [self.claimData politifactClaimSource];
    [self.factCheckDelegate loadURL:[sourcePressed claimSourceUrl] withTitle:@"PolitiFact"];
}

-(void)setClaimData:(NSDictionary *)claimData
{
    _claimData = claimData;
    NSInteger politifactIndex = [self.claimData politifactClaimSourceIndex];
    NSInteger factCheckIndex = [self.claimData factCheckOrgClaimSourceIndex];

    if(politifactIndex != -1){
        [self.politifactButton setEnabled:YES];
        [self.politifactCheckBox setImage:[UIImage imageNamed:@"checked_box.png"]];
    }else{
        [self.politifactButton setEnabled:NO];
        [self.politifactCheckBox setImage:[UIImage imageNamed:@"unchecked_box.png"]];        
    }
    
    if(factCheckIndex != -1){
        [self.factcheckButton setEnabled:YES];
        [self.factCheckCheckBox setImage:[UIImage imageNamed:@"checked_box.png"]];
    }else{
        [self.factcheckButton setEnabled:NO];
        [self.factCheckCheckBox setImage:[UIImage imageNamed:@"unchecked_box.png"]];        
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */// Configure the view for the selected state

@end
