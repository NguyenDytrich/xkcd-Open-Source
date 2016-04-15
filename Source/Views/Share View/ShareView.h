//
//  ShareView.h
//  xkcd Open Source
//
//  Created by Dytrich Nguyen on 4/7/16.
//  Copyright © 2016 Mike Amaral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "Comic.h"

@interface ShareView : UIView<FBSDKSharingDelegate>

@property (nonatomic, strong) Comic *comic;
@property (nonatomic, strong) UIViewController *comicVC;
@property (nonatomic, strong) UIImage *comicImage;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *shareLabel;
@property (nonatomic, strong) UITextView *permalinkTextView;

@property (nonatomic, strong) UIButton *facebookShareButton;
@property (nonatomic, strong) UIButton *twitterShareButton;
@property (nonatomic, strong) UIButton *cPermaLinkButton;

@property (nonatomic) BOOL isVisible;

- (instancetype)initViewController:(UIViewController *)comicVC;
- (void)layoutFacade;
- (void)showInView:(UIView *)superview comicImage:(UIImage *)comicImage;
- (void)dismiss;

@end
