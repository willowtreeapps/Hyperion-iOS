//
//  WTASlowAnimatonsViewController.m
//  HyperioniOS_Example
//
//  Created by Chris Mays on 11/27/17.
//  Copyright © 2017 chrsmys. All rights reserved.
//

#import "WTASlowAnimatonsViewController.h"

@interface WTASlowAnimatonsViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *slowAnimationsHeaderImageView;
@property (strong, nonatomic) IBOutlet UIImageView *normalSpeedImageView;
@property (strong, nonatomic) IBOutlet UIImageView *halfSpeedImageView;
@property (strong, nonatomic) IBOutlet UIImageView *threeQuartersImageView;

@end

@implementation WTASlowAnimatonsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.slowAnimationsHeaderImageView.image = [_slowAnimationsHeaderImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.normalSpeedImageView.alpha = 0;
    self.halfSpeedImageView.alpha = 0;
    self.threeQuartersImageView.alpha = 0;

    CATransform3D yTranslation = CATransform3DTranslate(CATransform3DIdentity, 0, -90, 0);

    self.normalSpeedImageView.layer.transform = yTranslation;
    self.halfSpeedImageView.layer.transform = yTranslation;
    self.threeQuartersImageView.layer.transform = yTranslation;

    [UIView animateKeyframesWithDuration:1.4 delay:0.0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{

        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.33 animations:^{
            self.normalSpeedImageView.layer.transform = CATransform3DIdentity;
            self.normalSpeedImageView.alpha = 1.0;
        }];

        [UIView addKeyframeWithRelativeStartTime:0.27 relativeDuration:0.33 animations:^{
            self.halfSpeedImageView.layer.transform = CATransform3DIdentity;
            self.halfSpeedImageView.alpha = 1.0;
        }];

        [UIView addKeyframeWithRelativeStartTime:0.54 relativeDuration:0.33 animations:^{
            self.threeQuartersImageView.layer.transform = CATransform3DIdentity;
            self.threeQuartersImageView.alpha = 1.0;
        }];
    } completion:nil];
}

- (IBAction)backButtonPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
