//
//  SPAudioTagViewController.m
//  SuperPAC
//
//  Created by Nick Donaldson on 7/18/12.
//
//

#import "SPAudioTagViewController.h"
#import "SPAdDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LocalyticsSession.h"
#import "UIImage+JTImageDecode.h"
#import "SPErrorPromptViewController.h"

#if !TARGET_IPHONE_SIMULATOR
#import "TunesatMobile.h"
static volatile bool _identificationCancelled;
static int tunesatCancelFunction(void *ref);
#endif

#ifdef DEBUG
#define kShowVerbose YES
#else
#define kShowVerbose NO
#endif

#define kListeningStartAnimationDuration 0.2
#define kNumberMaskFrames 30
#define kAnimationFrameDuration 0.05
#define kProgressAssetCapInsetX 4

@interface SPAudioTagViewController ()
{
    BOOL _eqAnimating;
    NSInteger _lastEqFrameIndex;
    
#if !TARGET_IPHONE_SIMULATOR
    tunesat_mobile::FingerprintCache *tunesatCache;
#endif
}

@property (nonatomic, strong) CALayer *animationMaskLayer;
@property (nonatomic, strong) NSMutableDictionary *animationFrameCache;

- (void)listeningStarted:(BOOL)started animated:(BOOL)animated;
- (void)updateStatusText:(NSString*)text animated:(BOOL)animated;
- (void)startAnimatingEqualizer;
- (void)stopAnimatingEqualizer;
- (void)eqAnimationTick;
- (void)showErrorPage;
- (UIImage*)animationMaskImageForFrame:(NSUInteger)frame;

#if !TARGET_IPHONE_SIMULATOR
- (void)cancelIdentification;
- (void)tunesatThreadOperation:(id)ignore;
- (void)tunesatIdentifactionSucceeded:(NSString*)uuid;
#endif
//Localytics helpers
-(void)logStartedListening;
-(void)logListeningSuccess:(NSString *)adId; //adId of the found ad
-(void)logListeningFailure:(NSString *)errorLocation; //  "during listening" or "during matching"
-(void)logIdentificationSucceeded:(BOOL)success tunesatFailed:(BOOL)tunesatFailed;
-(void)logIdentificationCancelled;
@end

@implementation SPAudioTagViewController

@synthesize animationHostView = _animationHostView;
@synthesize listenButton = _listenButton;
@synthesize animationBGImage = _animationBGImage;
@synthesize superPacLogoImage = _superPacLogoImage;
@synthesize statusLabel = _statusLabel;
@synthesize poweredByTunesatImage = _poweredByTunesatImage;
@synthesize progressView = _progressView;
@synthesize animationMaskLayer = _animationMaskLayer;
@synthesize animationFrameCache = _animationFrameCache;

@synthesize identificationInProgress = _identificationInProgress;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _eqAnimating = NO;
        _lastEqFrameIndex = 0;
#if !TARGET_IPHONE_SIMULATOR
        tunesatCache = new tunesat_mobile::FingerprintCache("default");
        _identificationCancelled = false;
#endif
    }
    return self;
}

#pragma mark - View Lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    
#if !TARGET_IPHONE_SIMULATOR
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelIdentification) name:kDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelIdentification) name:kWillResignActiveNotification object:nil];
#endif
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.progressView setProgressImage:[[UIImage imageNamed:@"progress_fill_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, kProgressAssetCapInsetX, 0, kProgressAssetCapInsetX)]];
    [self.progressView setTrackImage:[[UIImage imageNamed:@"progress_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, kProgressAssetCapInsetX, 0, kProgressAssetCapInsetX)]];
    
    CGFloat scale = [[UIScreen mainScreen] respondsToSelector:@selector(scale)] ? [[UIScreen mainScreen] scale] : 1.0;
    
    UIImage *defMask = [UIImage imageNamed:@"mask_0"];
    
    self.animationMaskLayer = [CALayer layer];
    _animationMaskLayer.frame = (CGRect){CGPointZero, self.animationHostView.frame.size};
    _animationMaskLayer.backgroundColor = [UIColor clearColor].CGColor;
    _animationMaskLayer.contentsScale = scale;
    _animationMaskLayer.contents = (__bridge id)defMask.CGImage;
    self.animationHostView.layer.mask = _animationMaskLayer;
    
    self.animationFrameCache = [NSMutableDictionary dictionaryWithCapacity:kNumberMaskFrames];
    for (NSUInteger i=1; i<kNumberMaskFrames; i++){
        UIImage *preload = [self animationMaskImageForFrame:i];
        if (preload){
            [self.animationFrameCache setObject:preload forKey:[NSNumber numberWithInt:i]];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
#if !TARGET_IPHONE_SIMULATOR
    _identificationCancelled = true;
#endif
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [_animationFrameCache removeAllObjects];
}


- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setAnimationHostView:nil];
    [self setListenButton:nil];
    [self setAnimationMaskLayer:nil];
    [self setAnimationBGImage:nil];
    [self setAnimationFrameCache:nil];
    [self setPoweredByTunesatImage:nil];
    [self setSuperPacLogoImage:nil];
    [self setStatusLabel:nil];
    [self setProgressView:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
#if !TARGET_IPHONE_SIMULATOR
    delete tunesatCache;
#endif
}

#pragma mark - Actions

-(IBAction)listenButtonPressed:(id)sender
{
    BOOL isStarting = !_identificationInProgress;
    [self listeningStarted:isStarting animated:YES];
}

#pragma mark - Private methods

- (void)listeningStarted:(BOOL)started animated:(BOOL)animated
{
    if (started){
        [self logStartedListening];
        
        _lastEqFrameIndex = 0;
        [self startAnimatingEqualizer];
        _identificationInProgress = YES;
        self.listenButton.selected = YES;
        self.progressView.progress = 0.0f;
        self.progressView.hidden = NO;
        
        if (animated){
            [UIView animateWithDuration:kListeningStartAnimationDuration
                             animations:^{
                                 self.poweredByTunesatImage.alpha = 1.0;
                             }];
            
            [UIView transitionWithView:self.superPacLogoImage
                              duration:kListeningStartAnimationDuration
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                self.superPacLogoImage.image = [UIImage imageNamed:@"SuperPacApp_logo_text_color_v2"];
                            }
                            completion:NULL];
            [self updateStatusText:@"Listening..." animated:YES];
        }
        else{
            self.poweredByTunesatImage.alpha = 1.0;
            self.superPacLogoImage.image = [UIImage imageNamed:@"SuperPacApp_logo_text_color_v2"];
            [self updateStatusText:@"Listening..." animated:NO];
        }
        
#if !TARGET_IPHONE_SIMULATOR
        [NSThread detachNewThreadSelector:@selector(tunesatThreadOperation:) toTarget:self withObject:nil];
#endif
    }
    else{
#if !TARGET_IPHONE_SIMULATOR
        [self logIdentificationCancelled];
        _identificationCancelled = true;
#else
        [self updateStatusText:@"Tap to explore the presidential ad you're watching now." animated:YES];
#endif
        [self stopAnimatingEqualizer];
        self.listenButton.selected = NO;
        [self stopAnimatingEqualizer];
        _identificationInProgress = NO;
        self.progressView.hidden = YES;
        
        if (animated){
            [UIView animateWithDuration:kListeningStartAnimationDuration
                             animations:^{
                                 self.poweredByTunesatImage.alpha = 0.0;
                             }];
            
            [UIView transitionWithView:self.superPacLogoImage
                              duration:kListeningStartAnimationDuration
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                self.superPacLogoImage.image = [UIImage imageNamed:@"SuperPacApp_logo_text_gray_v2"];
                            }
                            completion:NULL];
        }
        else{
            self.poweredByTunesatImage.alpha = 0.0;
            self.superPacLogoImage.image = [UIImage imageNamed:@"SuperPacApp_logo_text_gray_v2"];
        }
    }
}

- (void)updateStatusText:(NSString *)text animated:(BOOL)animated
{
    if (animated){
        [UIView transitionWithView:self.statusLabel
                          duration:kListeningStartAnimationDuration
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.statusLabel.text = text;
                        }
                        completion:NULL];
    }
    else{
        self.statusLabel.text = text;
    }
}



- (void)startAnimatingEqualizer
{
    _eqAnimating = YES;
    self.animationHostView.hidden = NO;
    
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = [NSNumber numberWithFloat:0];
    rotate.toValue = [NSNumber numberWithFloat:M_PI_2];
    rotate.duration = 2;
    rotate.repeatDuration = 240;
    rotate.cumulative = YES;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotate.fillMode = kCAFillModeForwards;
    
    [self.animationBGImage.layer addAnimation:rotate forKey:@"rotate"];
    
    [self eqAnimationTick];
}

- (void)stopAnimatingEqualizer
{
    _eqAnimating = NO;
    self.animationHostView.hidden = YES;
    [self.animationBGImage.layer removeAllAnimations];
}

- (void)eqAnimationTick
{
    if (!_eqAnimating) return;
    
    _lastEqFrameIndex = (_lastEqFrameIndex + 1) % kNumberMaskFrames;
    if (_lastEqFrameIndex+1 == 3)
        _lastEqFrameIndex = 3;

    UIImage *newMask = [self.animationFrameCache objectForKey:[NSNumber numberWithInt:_lastEqFrameIndex+1]];
    if (!newMask){
        newMask = [self animationMaskImageForFrame:_lastEqFrameIndex+1];
        if (newMask)
            [self.animationFrameCache setObject:newMask forKey:[NSNumber numberWithInt:_lastEqFrameIndex+1]];
    }

    [CATransaction begin];
    [CATransaction setAnimationDuration:0.001];
    _animationMaskLayer.contents = (__bridge id)newMask.CGImage;
    [CATransaction commit];
    [self performSelector:@selector(eqAnimationTick) withObject:nil afterDelay:kAnimationFrameDuration];
    
    // update progress slider
    float newProg = self.progressView.progress + kAnimationFrameDuration/30.0f;
    newProg = newProg > 1.0f ? 1.0f : newProg;
    [self.progressView setProgress:newProg animated:YES];
}
         
- (UIImage*)animationMaskImageForFrame:(NSUInteger)frame
{
    NSString *formatString = frame < 10 ? @"qt_eq_0%d" : @"qt_eq_%d";
    NSString *maskImageName = [NSString stringWithFormat:formatString, frame];
    return [UIImage decodedImageWithImage:[UIImage imageNamed:maskImageName]];
}


#if !TARGET_IPHONE_SIMULATOR

// called in response to background/inactive state change
- (void)cancelIdentification
{
    _identificationCancelled = YES;
}

-(void)tunesatThreadOperation:(id)ignore
{
    NSString *lastDebugMessage = @"Tunesat identification started";
//    LogDebug(lastDebugMessage);
    
	tunesat_mobile::Options options;
	char description[128];
	int err;
    
	@autoreleasepool {
		// allow user to stop identification
		_identificationCancelled=false;
                    
        // It all happens here:
        memset(&options, 0, sizeof(options));
        options.cancel_func=tunesatCancelFunction;
        
        
        // Open as background task - will be cancelled on transition to background, but this gives it a chance to actually cancel
        // before the app reaches the foreground again, otherwise you'll see it continue identifying briefly when foregrounding
        UIBackgroundTaskIdentifier bgId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
        
        err=tunesat_mobile::identify(tunesatCache, &options, description, sizeof(description));
        
        Boolean systemErr = false;
        
        NSString *tunesatUUID = nil;
        
        // display result (or error)
        switch(err){
            case tunesat_mobile::kErrCancel:	// user clicked "Stop"
                lastDebugMessage = @"Tunesat identification cancelled";
                LogDebug(@"Tunesat identification cancelled");
                break;
                
            case tunesat_mobile::kErrNone:{	// a match was found
                lastDebugMessage = [NSString stringWithFormat:@"Tunesat identification succeeded: %s", description];

                LogDebug(@"Tunesat identification succeeded: %s", description);
                tunesatUUID = [NSString stringWithCString:description encoding:NSUTF8StringEncoding];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self tunesatIdentifactionSucceeded:tunesatUUID];
                });
                [[UIApplication sharedApplication] endBackgroundTask:bgId];
                return;
            } break;
                
            case tunesat_mobile::kErrNetwork:
                LogDebug(@"Tunesat identification network error");
                lastDebugMessage = [NSString stringWithFormat:@"Tunesat identification network error"];

                systemErr = true;
                break;
                
            case tunesat_mobile::kErrConnectTimeout:
                LogDebug(@"Tunesat identification timeout (failed)");
                lastDebugMessage = [NSString stringWithFormat:@"Tunesat identification timeout (failed)"];

                systemErr = true;
                break;
                
            case tunesat_mobile::kErrBadVersion:
                lastDebugMessage = [NSString stringWithFormat:@"Tunesat identification software version mismatch"];

                LogDebug(@"Tunesat identification software version mismatch");
                systemErr = true;
                break;
                
            case tunesat_mobile::kErrServerBusy:

                lastDebugMessage = [NSString stringWithFormat:@"Tunesat identification server busy"];

                LogDebug(@"Tunesat identification server busy");
                systemErr = true;
                break;
                
            case tunesat_mobile::kErrWeakSignal:
                lastDebugMessage = [NSString stringWithFormat:@"Tunesat identification signal too weak"];
                LogDebug(@"Tunesat identification signal too weak");
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Turn it up!" message:@"The volume on that ad was a little low. Please try getting a little closer or turning up the volume." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                });
                break;
                
            case tunesat_mobile::kErrSessionTimeout: {
                lastDebugMessage = [NSString stringWithFormat:@"Tunesat identification failed to identify"];

                LogDebug(@"Tunesat identification failed to identify");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self logIdentificationSucceeded:NO tunesatFailed:YES];
                    [self showErrorPage];
                });    
            } break;
                
            case tunesat_mobile::kErrSoundInput:
                lastDebugMessage = [NSString stringWithFormat:@"Tunesat identification audio input error"];

                LogDebug(@"Tunesat identification audio input error");
                break;
                
            case tunesat_mobile::kErrFPServer:
                lastDebugMessage = [NSString stringWithFormat:@"Tunesat identification failed to load fingerprints from server"];
                
                LogDebug(@"Tunesat identification failed to load fingerprints from server");
                systemErr = true;
                break;
                
            default:
                lastDebugMessage = [NSString stringWithFormat:@"Tunesat identification unknown error %d while identifying!\n", err];
                LogDebug(@"Tunesat identification unknown error");
                fprintf(stderr, "Unknown error err=%d while identifying!\n", err);
                //[self asyncSetStatusWithString: @"Unknown error while identifying!"];
                break;
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (systemErr){
                if(kShowVerbose){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR!" message:lastDebugMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"There was an error with identification. Please check your internet connection and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            }
            
            [self listeningStarted:NO animated:YES];
            [self updateStatusText:@"Tap to explore the presidential ad you're watching now." animated:YES];
            
        });
        [[UIApplication sharedApplication] endBackgroundTask:bgId];
	}
}

int tunesatCancelFunction(void *ref)
{
    if (_identificationCancelled) return tunesat_mobile::kErrCancel;
    return tunesat_mobile::kErrNone;
}

- (void)tunesatIdentifactionSucceeded:(NSString *)uuid
{
    [self updateStatusText:@"Matching..." animated:YES];
    [[SPDataManager sharedInstance] getAdForTunesatUUID:uuid withDelegate:self];
}

#endif

- (void)showErrorPage {
    SPErrorPromptViewController* errorVC = [[SPErrorPromptViewController alloc] init];
    [self.navigationController pushViewController:errorVC animated:YES];
}

#pragma mark - SPDataManager delegate

-(void)getAdForTunesatUUIDFinishedWithAd:(NSDictionary *)ad error:(NSError *)error
{
    
    [self listeningStarted:NO animated:YES];
    [self updateStatusText:@"Tap to explore the presidential ad you're watching now." animated:YES];
    
    if (error || !ad){
        if ([error code] == 500){
            [self logIdentificationSucceeded:NO tunesatFailed:NO];
        }
        [self showErrorPage];
    }
    else{
        [self logIdentificationSucceeded:YES tunesatFailed:NO];
        SPAdDetailsViewController *adDetailsVC = [[SPAdDetailsViewController alloc] initWithNibName:nil bundle:nil];
        [adDetailsVC setAdDataDict:ad];
        [self.navigationController pushViewController:adDetailsVC animated:YES];
    }
}

#pragma mark - Localytics helpers
-(void)logStartedListening
{
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Started listening"];
}

-(void)logListeningSuccess:(NSString *)adId 
{
//    NSDictionary *reportingAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:adId, @"Ad id", nil];
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Listening success" attributes:nil reportAttributes:nil];
}

-(void)logListeningFailure:(NSString *)errorLocation 
{ //errorLocation = "during listening" or "during matching" depeding on the phase that the failure occurs
    NSDictionary *attributes = [[NSDictionary alloc] initWithObjectsAndKeys:errorLocation, @"Error", nil];
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Listening failure" attributes:attributes];
}

-(void)logIdentificationSucceeded:(BOOL)success tunesatFailed:(BOOL)tunesatFailed
{
    if (success){
        [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Ad Identified"];
    }
    else if (tunesatFailed){
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:@"TuneSat Identification Timed Out" forKey:@"Result"];
        [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Ad Identification Failed" attributes:attributes];
    }
    else{
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:@"Not in Glassy Database" forKey:@"Result"];
        [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Ad Identification Failed" attributes:attributes];
    }
}

-(void)logIdentificationCancelled
{
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Ad Identification Cancelled"];
}

@end
