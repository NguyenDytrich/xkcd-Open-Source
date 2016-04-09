//
//  ShareView.m
//  xkcd Open Source
//
//  Created by Dytrich Nguyen on 4/7/16.
//  Copyright © 2016 Mike Amaral. All rights reserved.
//

#import "ShareView.h"
#import "ThemeManager.h"
#import <UIView+Facade.h>
#import <TwitterKit/TwitterKit.h>
#import <GTTracker.h>

static CGFloat const kButtonSize = 50.0;

@implementation ShareView


- (instancetype)initViewController:(UIViewController *)comicVC {
    self = [super init];
    
    [self setupShareView];
    
    return self;
}

- (void)setupShareView {
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    
    self.containerView = [UIView new];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.containerView];
    
    [ThemeManager addBorderToLayer:self.containerView.layer radius:kDefaultCornerRadius color:[UIColor whiteColor]];
    [ThemeManager addShadowToLayer:self.containerView.layer radius:15.0 opacity:0.8];
    [ThemeManager addParallaxToView:self.containerView];
    
    self.shareLabel = [UILabel new];
    self.shareLabel.font = [ThemeManager xkcdFontWithSize:18];
    self.shareLabel.textAlignment = NSTextAlignmentCenter;
    self.shareLabel.numberOfLines = 0;
    self.shareLabel.text = @"Share";
    [self.containerView addSubview:self.shareLabel];
    
    self.permalinkTextView = [UITextView new];
    self.permalinkTextView.editable = NO;
    [self.containerView addSubview:self.permalinkTextView];
    
    self.facebookShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.facebookShareButton setImage:[ThemeManager facebookImage] forState:UIControlStateNormal];
    [self.facebookShareButton addTarget:self action:@selector(handleFacebookShare) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.facebookShareButton];
    
    self.twitterShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.twitterShareButton setImage:[ThemeManager twitterImage] forState:UIControlStateNormal];
    [self.twitterShareButton addTarget:self action:@selector(handleTwitterShare) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:self.twitterShareButton];
}

#pragma mark - Layout

- (void)layoutFacade {
    CGFloat width = CGRectGetWidth(self.superview.frame) * 0.8;
    CGFloat height = CGRectGetHeight(self.superview.frame) * 0.3;
    CGFloat padding = CGRectGetHeight(self.superview.frame) - (3 * height);
    
    [self fillSuperview];
    [self.containerView anchorInCenterWithWidth:width height:height];
    
    [self.shareLabel sizeToFit];
    [self.shareLabel anchorTopCenterWithTopPadding:padding width:width height:20];
    
    [self.permalinkTextView alignUnder:self.shareLabel matchingCenterWithTopPadding:10.0 width:width height:20];
    
    [self.facebookShareButton anchorBottomCenterWithBottomPadding:15 width:kButtonSize height:kButtonSize];
    [self.twitterShareButton alignToTheLeftOf:self.facebookShareButton matchingCenterWithRightPadding:15 width:kButtonSize height:kButtonSize ];
}

#pragma mark - Showing and hiding

- (void)showInView:(UIView *)superview comicImage:(UIImage *)comicImage {
    [superview addSubview:self];
    
    self.comicImage = comicImage;
    self.permalinkTextView.text = [[self.comic generateShareURL] absoluteString];
    
    [self layoutFacade];
    self.isVisible = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        self.isVisible = NO;
    }];
}

#pragma mark - Facebook Sharing

- (void)handleFacebookShare {
    FBSDKShareLinkContent *shareLinkContent = [FBSDKShareLinkContent new];
    shareLinkContent.contentTitle = self.comic.safeTitle;
    shareLinkContent.contentURL = [self.comic generateShareURL];
    
    [FBSDKShareDialog showFromViewController:self.comicVC withContent:shareLinkContent delegate:self];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    [[GTTracker sharedInstance] sendAnalyticsEventWithCategory:@"Social Share" action:@"Facebook" label:@"Cancel"];
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    [[GTTracker sharedInstance] sendAnalyticsEventWithCategory:@"Social Share" action:@"Facebook" label:[NSString stringWithFormat:@"Error: %@", error.localizedDescription]];
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    [[GTTracker sharedInstance] sendAnalyticsEventWithCategory:@"Social Share" action:@"Facebook" label:@"Success"];
}


#pragma mark - Twitter sharing

- (void)handleTwitterShare {
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Uh oh..." message:[NSString stringWithFormat:@"Twitter said something went wrong. Don't blame me..."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return;
        }
        
        TWTRComposer *composer = [TWTRComposer new];
        [composer setText:self.comic.safeTitle];
        [composer setImage:self.comicImage];
        [composer setURL:[self.comic generateShareURL]];
        [composer showFromViewController:self.comicVC completion:^(TWTRComposerResult result) {
            [[GTTracker sharedInstance] sendAnalyticsEventWithCategory:@"Social Share" action:@"Twitter" label:(result == TWTRComposerResultCancelled) ? @"Cancel" : @"Success"];
        }];
    }];
}

#pragma mark  - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

@end
