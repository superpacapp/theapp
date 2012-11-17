//
//  SPShareController.m
//  SuperPAC
//
//  Created by Alex Rouse on 7/24/12.
//  Copyright (c) 2012 Raizlabs. All rights reserved.
//

#import "SPShareController.h"
#import "SPAppDelegate.h"
#import "NSDictionary+Ad.h"
#import "NSDictionary+Committee.h"
#import "SPDataManager.h"

#define kMaxTwitterCharacters   139

static SPShareController *_sharedDataManager;

@interface SPShareController () 
@property (nonatomic, weak) UIViewController* shareVC;

@end

@implementation SPShareController
@synthesize facebook = _facebook;
@synthesize currentAd = _currentAd;
@synthesize currentClaim = _currentClaim;
@synthesize shareVC = _shareVC;
@synthesize isClaim = _isClaim;
+(SPShareController*)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataManager = [[SPShareController alloc] init];
    });
    return _sharedDataManager;
}

- (void)composeEmailForAd:(NSDictionary *)ad withImage:(UIImage *)detailsImage
{
    if (![MFMailComposeViewController canSendMail]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Email is not set up on this device, please add an email account and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
	}
	MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    NSString *emailSubject = nil;
    NSString *emailHTMLBody = nil;
	
    NSString* rating = [[SPDataManager sharedInstance] tagForAdId:ad.adId];
    if (!rating || self.isClaim) {
        emailSubject = @"I just used the Super PAC App";
        emailHTMLBody = [NSString stringWithFormat:@"Check it out! I just used the Super PAC App to learn more about %@'s recent ad.  See the ad and rate it with the <a href=\"%@\">Super PAC App</a>", ad.committee.committeeName, ITUNES_URL];
    } else {
        emailSubject = @"I just used the Super PAC App";
        emailHTMLBody = [NSString stringWithFormat:@"%@! That's what I just rated %@'s recent ad. See the ad and rate it too via <a href=\"%@\">Super PAC App</a>", [rating capitalizedString], ad.committee.committeeName, ITUNES_URL];
    }
    
    [mailComposer setSubject:emailSubject];
	[mailComposer setMessageBody:emailHTMLBody isHTML:YES];
	
	if (detailsImage) {
		NSData *attachedImageData = UIImageJPEGRepresentation(detailsImage, 1.0);
        if (attachedImageData) {
            [mailComposer addAttachmentData:attachedImageData mimeType:@"image/jpeg" fileName:@"image.jpg"];
        }
	}
	
	mailComposer.mailComposeDelegate = self;
    
    [self presentShareVC:mailComposer];
}

- (void)composeMessageForAd:(NSDictionary *)ad;
{
    if (![MFMessageComposeViewController canSendText]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please set up Messages and try again." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
        return;
	}
    MFMessageComposeViewController *messageCompose = [[MFMessageComposeViewController alloc] init];
    messageCompose.messageComposeDelegate = self;
    messageCompose.navigationBar.barStyle = UIBarStyleBlack;
    
    NSString *messageBody = @"";
    
    NSString* rating = [[SPDataManager sharedInstance] tagForAdId:ad.adId];
//    if (self.isClaim) {
//        messageBody = [NSString stringWithFormat:@"Just learned more about %@'s recent ad via Super PAC App",ad.committee.committeeName, ITUNES_URL];
//        self.isClaim = NO;
//    }
    if (!rating || self.isClaim) {
       messageBody = [NSString stringWithFormat:@"Just used the Super PAC App to learn more about %@’s recent ad. Check it out. %@", ad.committee.committeeName, ITUNES_URL];
    } else {
        NSString *adjustedRating = [NSString stringWithFormat:([rating isEqualToString:kAdTagFair] ? @"%@." : @"%@!"), [rating capitalizedString]]; 

        messageBody = [NSString stringWithFormat:@"%@ Just used the Super PAC App to rate %@’s recent ad. Check it out. %@",adjustedRating, ad.committee.committeeName, ITUNES_URL];
    }

    [messageCompose setBody:messageBody];
    [self presentShareVC:messageCompose];    
}

- (void)composeTweetForAd:(NSDictionary *)ad withImage:(UIImage *)detailsImage
{    
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    NSString* tweet = nil;

    NSString* rating = [[SPDataManager sharedInstance] tagForAdId:ad.adId];
    if (!rating || self.isClaim) {
        tweet = [NSString stringWithFormat:@"Just used @superpacapp to learn more about %@’s recent ad. Check out the ad, its claims, and rate it at %@", ad.committee.committeeName, ITUNES_URL];
    } else {
        NSString *adjustedRating = [NSString stringWithFormat:@"%@!", [rating capitalizedString]]; 
        if([rating isEqualToString:@"love"]){
            adjustedRating = @"Heart!";
        }

        tweet = [NSString stringWithFormat:@"%@ That's what I just rated %@’s recent ad via @superpacapp. %@",adjustedRating, ad.committee.committeeName, ITUNES_URL];
    }
    if (tweet.length >= kMaxTwitterCharacters) {
        LogDebug(@"Tweet is %d characters reformatting.",tweet.length);
        tweet = [NSString stringWithFormat:@"Just used @superpacapp to learn more about %@’s recent ad.",ad.committee.committeeName];
        if (tweet.length >= kMaxTwitterCharacters) {
            tweet = [NSString stringWithFormat:@"Just used @superpacapp. Check it out at %@", ITUNES_URL];
        }
    }

    
    if (detailsImage)
        [tweetViewController addImage:detailsImage];
    
    [tweetViewController setInitialText:tweet];
    
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
                
        switch (result) {
            case TWTweetComposeViewControllerResultCancelled:
                [self dismissShareVC];
                break;
            case TWTweetComposeViewControllerResultDone:
                [self dismissShareVC];
                break;
            default:
                break;
        }
        
    }];
    [self presentShareVC:tweetViewController];
}

- (void)composeFacebookForAd:(NSDictionary *)ad
{
    
    if (ad == nil) {
        ad = self.currentAd;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if (![self.facebook isSessionValid]) {
        self.currentAd = ad;
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_stream", 
                                nil];
        [self.facebook authorize:permissions];
    } else {
        self.currentAd = nil;
        NSString* rating = [[SPDataManager sharedInstance] tagForAdId:ad.adId];
        NSMutableDictionary* params;
        if (!rating || self.isClaim) {
            params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                       FACEBOOK_APPID, @"app_id",
                       API_ENDPOINT, @"link",
                       @"I Just Used the Super PAC App", @"name",
                      [NSString stringWithFormat:@"I just used Super PAC App to learn more about %@'s recent ad.  Check out the ad, it's claims, and rate it.", ad.committee.committeeName], @"description",
                       nil];
        } else {
            NSString *adjustedRating = [NSString stringWithFormat:@"%@!", [rating capitalizedString]]; 
            if([rating isEqualToString:@"love"]){
                adjustedRating = @"Heart!";
            }

            params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      FACEBOOK_APPID, @"app_id",
                      API_ENDPOINT, @"link",
                      @"I Just Used the Super PAC App", @"name",
                      [NSString stringWithFormat:@"%@ That's what I rated %@'s recent ad via Super PAC App.  Check out the ad and rate it too.", adjustedRating, ad.committee.committeeName], @"description",
                      nil];
        }
        [self.facebook dialog:@"feed" andParams:params andDelegate:self];
    }
}

- (void)presentShareVC:(UIViewController *)vc {
    [[((SPAppDelegate *)[[UIApplication sharedApplication] delegate]) rootTabBarController] presentModalViewController:vc animated:YES];
    self.shareVC = vc;
}
- (void)dismissShareVC {
    [self.shareVC dismissModalViewControllerAnimated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result) {
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			break;
		default:
            break;	
    }
    
[self dismissShareVC];    
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissShareVC];   
    if (result == MessageComposeResultSent) {

    }
    else if (result == MessageComposeResultFailed) {
        
    }
    
}




@end
