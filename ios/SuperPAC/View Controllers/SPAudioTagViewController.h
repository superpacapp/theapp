//
//  SPAudioTagViewController.h
//  SuperPAC
//
//  Created by Nick Donaldson on 7/18/12.
//
//

#import <UIKit/UIKit.h>
#import "SPDataManager.h"

@interface SPAudioTagViewController : UIViewController <SPDataManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *animationHostView;
@property (weak, nonatomic) IBOutlet UIButton *listenButton;
@property (weak, nonatomic) IBOutlet UIImageView *animationBGImage;
@property (weak, nonatomic) IBOutlet UIImageView *superPacLogoImage;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *poweredByTunesatImage;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (assign, readonly, nonatomic) BOOL identificationInProgress;

- (IBAction)listenButtonPressed:(id)sender;

@end
