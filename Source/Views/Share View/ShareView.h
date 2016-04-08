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

@interface ShareView : UIView

@property (nonatomic, strong) Comic *comic;
@property (nonatomic, strong) UIViewController<FBSDKSharingDelegate> *comicVC;
@property (nonatomic, strong) UIImage *comicImage;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *shareLabel;
@property (nonatomic, strong) UILabel *permaLinkLabel;

@property (nonatomic, strong) UIButton *facebookShareButton;
@property (nonatomic, strong) UIButton *twitterShareButton;

@property (nonatomic) BOOL isVisible;

- (instancetype)initWithDelegate:(UIViewController<FBSDKSharingDelegate> *)comicVC;
- (void)layoutFacade;
- (void)showInView:(UIView *)superview comicImage:(UIImage *)comicImage;
- (void)dismiss;

@end
